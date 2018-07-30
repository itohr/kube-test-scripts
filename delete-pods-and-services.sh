#!/bin/bash

name=$1

echo "Deleting Pod and Services: $name"

sudo kubectl get deploy | grep $name | awk '{print $1}' | sudo xargs kubectl delete deploy 2> /dev/null
sudo kubectl get svc | grep $name | awk '{print $1}' | sudo xargs kubectl delete svc 2> /dev/null

echo "Done"
