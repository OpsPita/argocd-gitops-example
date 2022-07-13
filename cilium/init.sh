#!/bin/bash
docker pull quay.io/cilium/cilium:v1.11.6
kind load docker-image quay.io/cilium/cilium:v1.11.6 --name omri


