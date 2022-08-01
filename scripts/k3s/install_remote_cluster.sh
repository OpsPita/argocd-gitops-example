#!/bin/bash


export HOST="$1"
k3sup install --host $HOST --user root \
  --ssh-key $HOME/bak/id_rsa_omri \
  --ssh-port 22505
