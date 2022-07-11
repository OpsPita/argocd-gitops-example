#!/bin/bash
helm repo add cilium https://helm.cilium.io/
docker pull quay.io/cilium/cilium:v1.11.6
kind load docker-image quay.io/cilium/cilium:v1.11.6 --name omri
docker pull quay.io/argoproj/argocd:v2.4.4
kind load docker-image quay.io/argoproj/argocd:v2.4.4 --name omri



