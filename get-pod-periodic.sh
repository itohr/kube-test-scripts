#!/bin/bash

rate=$1

clean_up() {
  kill 0
  exit 0
}

send_request() {
  result=$(sh -c "TIMEFORMAT=$'%3R'; time sudo kubectl get pod -n kube-system > /dev/null" 2>&1)
  echo "ID: $2, Request No.$1, time[sec]: ${result}" | tee -a $tmp_file
}

trap 'clean_up' INT TERM

periodic_request() {
  count=0
  id=$1

  while :
  do
    send_request $count $id &
    count=$(expr $count + 1)
    sleep 0.1
  done
}

num_child=$(( $rate / 10 ))

for i in `seq 1 $num_child`
do
  periodic_request $i &
done

wait
