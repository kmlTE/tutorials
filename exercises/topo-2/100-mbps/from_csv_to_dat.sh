#!/usr/bin/env bash

algo_dir=$1
next_dir=$2
iperf_time=$3

## tcp bandwidth
for i in $(seq 1 3); do
	suffix=h${i}
	filename=${algo_dir}/${next_dir}/graphs/bw-tcp/data/${suffix}.dat
	echo $filename
	echo 0 | nl -b a -v 0 | tee $filename
	cat ${algo_dir}/${next_dir}/raw/tcp/h$(( $i+3 ))-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 9 | nl -b a -i 1 -v 1 | tee -a $filename
done


## udp bandwidth
for i in $(seq 1 3); do
	suffix=h${i}
	filename=${algo_dir}/${next_dir}/graphs/bw-udp/data/${suffix}.dat
	echo $filename
	echo 0 | nl -b a -v 0 | tee $filename
	cat ${algo_dir}/${next_dir}/raw/udp/h$(( $i+3 ))-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 9 | nl -b a -i 1 -v 1 | tee -a $filename
done