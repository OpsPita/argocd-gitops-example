#!/bin/bash
##Installing ArgoCD to newly created cluster
if [[ $(kubectl cluster-info) ]]
then
        kubectl create namespace argocd
        kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
fi

while true
do
	kubectl get pod -n argocd | grep argocd-repo-server |grep -i Running
	if [[ $? -ne 0 ]]
	then
        	sleep 2
	        echo "[?] Waiting for argocd to be ready"
	else
		kubectl apply -k kustomization/overlays/dev/app-of-apps/.
		echo "[*] Argo ready - init app-of-apps deployed"
		break
	fi
done
#Apply App-of-Apps to automaticly sync core folder
echo "Deployment Done"

