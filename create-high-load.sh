#!/bin/bash

echo "Create high load Pod"
sudo kubectl run high-load --image=polinux/stress --replicas 2 --command -- stress --verbose $@
