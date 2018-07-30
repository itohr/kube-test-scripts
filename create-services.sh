#!/bin/bash

count=$1

echo "Create nginx pod"
sudo kubectl run nginx --image=nginx --port 80

for i in `seq 1 $count`
do
  echo "Create service$i"
  sudo kubectl expose deploy nginx --name=nginx-svc$i
done
