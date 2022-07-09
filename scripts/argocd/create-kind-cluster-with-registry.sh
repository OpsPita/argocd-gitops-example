#!/bin/sh
set -o errexit


if [[ -z $1 ]]
then
	me=`basename "$0"`
	echo  "Please specifiy name after the command\n./${me} cluster-name"
	exit 1
fi

# create registry container unless it already exists
reg_name='kind-registry'
reg_port='5001'
if [ "$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)" != 'true' ]; then
  docker run \
    -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" \
    registry:2
fi

# create a cluster with the local registry enabled in containerd
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: ${1}
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${reg_port}"]
    endpoint = ["http://${reg_name}:5000"]
EOF

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
          kubectl create namespace argocd
          kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
  fi

  echo "Checking to see if argo initated"
  while true
  do
  	kubectl get pod -n argocd | grep argocd-repo-server |grep -i Running
  	if [[ $? -ne 0 ]]
  	then
          	sleep 2
  	        echo "[?] Waiting for argocd to be ready"
  	else
  		sleep 5
  		kubectl apply -k ../../kustomization/overlays/dev/app-of-apps/.
  		echo "[*] Argo ready - init app-of-apps deployed"
  		break
  	fi
  done
  #Apply App-of-Apps to automaticly sync core folder
  echo "Deployment Done"


}

argocdInit