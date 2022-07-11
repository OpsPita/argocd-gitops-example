#!/bin/bash


helm install cilium cilium/cilium --version 1.11.6 \
   --namespace kube-system \
   --set kubeProxyReplacement=partial \
   --set hostServices.enabled=false \
   --set externalIPs.enabled=true \
   --set nodePort.enabled=true \
   --set hostPort.enabled=true \
   --set bpf.masquerade=false \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes
