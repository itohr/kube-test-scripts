#!/bin/bash

interval=1
tmp_file="./.get-pod-response.log"

clean_up() {
  calc_summary
  rm -f $tmp_file && exit 0
}

calc_summary() {
  max=`cat $tmp_file | awk '{if(m<$4) m=$4} END{print m}'`
  average=`cat $tmp_file | awk '{m+=$4} END{printf("%.3f", m/NR)}'`

  echo ""
  echo "SUMMARY"
  echo "Max: $max [sec]"
  echo "Average: $average [sec]"
}

send_request() {
  result=$(sh -c "TIMEFORMAT=$'%3R'; time sudo kubectl get pod -n kube-system > /dev/null" 2>&1)
  echo "Request No.$1, time[sec]: ${result}" | tee -a $tmp_file
}

for i in `seq 1 10`
do
  send_request $i &
  sleep $interval
done

wait

clean_up
