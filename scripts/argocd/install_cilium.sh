#!/bin/bash


#!/bin/bash
docker pull quay.io/cilium/cilium:v1.11.6
kind load docker-image quay.io/cilium/cilium:v1.11.6 --name omri


helm upgrade -i cilium cilium/cilium --version 1.11.6 \
   --namespace kube-system \
   --set kubeProxyReplacement=partial \
   --set hostServices.enabled=false \
   --set externalIPs.enabled=true \
   --set nodePort.enabled=true \
   --set hostPort.enabled=true \
   --set bpf.masquerade=false \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes \
   --set cluster.name=${1} \
   --set cluster.id=${2}
