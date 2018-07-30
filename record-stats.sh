#!/bin/bash

record_date=`date +"%y%m%d-%H%M"`

usage() {
  echo "Usage: $0 dir process1 process2 ..." 1>&2
  exit 1
}

# Clean up job.
cleanup() {
  echo "Stop messuring."
  kill 0
}

# Signal handler.
trap cleanup INT TERM

do_pidstat() {
  process=$1
  pid=`ps -ef | grep $process | grep -v "grep" | grep -v $0 | awk '{if($8 ~ /'$1'/) print $2}'`
  echo "PID: $pid"
  pidstat -p $pid -udrh 5 > $2/$1_${record_date}.log &
}

# Check number of parameters.
if [ $# -lt 2 ]
then
  usage
fi

# Get directory path.
result_dir=$1
shift

# Get processes
declare -a processes=()
for i in `seq 1 $#`
do
  processes+=( $1 )
  shift
done

echo "${processes[@]}"

for process in ${processes[@]}
do
  echo "Start messuring the resource usage of $process"
  do_pidstat $process $result_dir
done

sar -n DEV 5 > ${result_dir}/nw-traffic_${record_date}.log

wait
