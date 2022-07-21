#!/bin/sh
set -o errexit


if [[ -z $1 ]]
then
	me=`basename "$0"`
	echo  "Please specifiy name after the command\n./${me} cluster-name"
	exit 1
fi

./create_registry.sh
# create a cluster with the local registry enabled in containerd
if [[ $(kind get clusters | grep ${1}) ]]
then
  echo "cluster already exists continue"
  else
    cat <<EOF | kind create cluster --config=-
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    name: ${1}
    nodes:
    - role: control-plane
    - role: worker
    networking:
      disableDefaultCNI: true
      podSubnet: "10.10.0.0/16"
      serviceSubnet: "10.11.0.0/16"
    containerdConfigPatches:
    - |-
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:5001"]
        endpoint = ["http://registry:5001"]
EOF
fi
# connect the registry to the cluster network if not already connected
if [ "$(docker inspect -f='{{json .NetworkSettings.Networks.kind}}' "${reg_name}")" = 'null' ]; then
  docker network connect "kind" "${reg_name}"
fi

# Document the local registry
# https://github.com/kubernetes/enhancements/tree/master/keps/sig-cluster-lifecycle/generic/1755-communicating-a-local-registry
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:${reg_port}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF

sleep 5


function argocdInit () {
  #!/bin/bash
  ##Installing ArgoCD to newly created cluster
  if [[ $(kubectl cluster-info) ]]
  then
          if [[ $(kubectl get ns | grep "argocd") ]]
          then
              echo "argocd ns available continue"
          else
            kubectl create namespace argocd
            kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
          fi
  fi

  echo "Checking to see if argo initated"
  while true
    do

      if [[ $(kubectl get pod -n argocd | grep argocd-repo-server |grep -i Running) ]]
      then
              sleep 5
              kubectl apply -k ../../kustomization/overlays/dev/app-of-apps/.
              echo "[*] Argo ready - init app-of-apps deployed"
              break
      else
              sleep 2
              echo "[?] Waiting for argocd to be ready"
      fi
    done
    #Apply App-of-Apps to automaticly sync core folder
    echo "Deployment Done"
}

./install_cilium.sh $1 2

argocdInit
