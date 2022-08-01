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
argocdInit
