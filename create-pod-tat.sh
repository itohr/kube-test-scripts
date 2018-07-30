#!/bin/bash

count=$1

send_request() {
  sudo kubectl run kube-create-test --image nginx > /dev/null 2>&1
  pod_name=`sudo kubectl get pod | grep "kube-create-test" | awk '{print $1}'`
  while :
  do
    pod_status=`sudo kubectl get pod | grep "kube-create-test" | awk '{print $3}'`
    
    if [ "$pod_status" = "Running" ]
    then
      break
    fi

    sleep 0.5
  done
}

TIMEFORMAT=$'%3R'

sum=0
for i in `seq 1 $count`
do
  echo "Create Pod Request: No.$i"
  result=`(time send_request) 2>&1`
  echo "time[sec]: $result"

  sudo kubectl delete deploy kube-create-test > /dev/null 2>&1

  sum=`echo $sum | awk -v result=$result '{printf("%.3f", $1 + result)}'`
done

average=`echo $sum | awk -v count=$count '{printf("%.3f", $1 / count)}'`
echo ""
echo "Average: $average [sec]"
