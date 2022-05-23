#!/bin/bash


kubectl delete -k kustomization/overlays/dev/app-of-apps/.
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
kubectl delete ns argocd

