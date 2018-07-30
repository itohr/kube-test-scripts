#!/bin/bash

count=$1
bandwidth=$2

for i in `seq 1 $count`
do
  echo "Create iperf-server$i"
  sudo kubectl run iperf-server$i --image=networkstatic/iperf3 --port 5201 --command -- iperf3 -s
  sudo kubectl expose deploy iperf-server$i

  echo "Create iperf-client$i"
  sudo kubectl run iperf-client$i --image=networkstatic/iperf3 --command -- iperf3 -c iperf-server$i.default.svc.cluster.local -t 3600 -b $bandwidth
done
