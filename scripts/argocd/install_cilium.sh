#!/bin/bash


#!/bin/bash
docker pull quay.io/cilium/cilium:v1.11.6
kind load docker-image quay.io/cilium/cilium:v1.11.6 --name omri


helm upgrade -i cilium cilium/cilium --version 1.11.6 \
   --namespace kube-system \
   -f cilium_values.yaml
