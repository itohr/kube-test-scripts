#!/bin/bash

count=$1

for i in `seq 1 $1`
do
  echo "Send create request: $i"
  sudo kubectl run kube-test-$i --image nginx > /dev/null 2>&1
  sleep 0.5
done
