#!/usr/bin/env bash

algo_dir=$1
next_dir=$2
iperf_time=$3
iperf_period=$(( $iperf_time / 3 ))


## tcp bandwidth
suffix=h1
filename=${algo_dir}/${next_dir}/graphs/bw-tcp/data/${suffix}.dat
echo $filename
yes "0" | head -n $(( $iperf_period + 1 )) | nl -b a -v 0 | tee $filename
cat ${algo_dir}/${next_dir}/raw/tcp/h4-iperf.csv | grep -v "0.0-${iperf_period}" | grep ",10.0.1.1," | cut -d ',' -f 9 | nl -b a -i 1 -v $(( $iperf_period + 1 )) | tee -a $filename
yes "0" | head -n $iperf_period | nl -b a -v $(( $iperf_period * 2 + 1 )) | tee -a $filename

for i in $(seq 2 3); do
	suffix=h${i}
	filename=${algo_dir}/${next_dir}/graphs/bw-tcp/data/${suffix}.dat
	echo $filename
	echo 0 | nl -b a -v 0 | tee $filename
	cat ${algo_dir}/${next_dir}/raw/tcp/h$(( $i+3 ))-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 9 | nl -b a -i 1 -v 1 | tee -a $filename
done


## udp bandwidth
suffix=h1
filename=${algo_dir}/${next_dir}/graphs/bw-udp/data/${suffix}.dat
echo $filename
yes "0" | head -n $(( $iperf_period + 1 )) | nl -b a -v 0 | tee $filename
cat ${algo_dir}/${next_dir}/raw/tcp/h4-iperf.csv | grep -v "0.0-${iperf_period}" | grep ",10.0.1.1," | cut -d ',' -f 9 | nl -b a -i 1 -v $(( $iperf_period + 1 )) | tee -a $filename
yes "0" | head -n $iperf_period | nl -b a -v $(( $iperf_period * 2 + 1 )) | tee -a $filename

for i in $(seq 2 3); do
	suffix=h${i}
	filename=${algo_dir}/${next_dir}/graphs/bw-udp/data/${suffix}.dat
	echo $filename
	echo 0 | nl -b a -v 0 | tee $filename
	cat ${algo_dir}/${next_dir}/raw/udp/h$(( $i+3 ))-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 9 | nl -b a -i 1 -v 1 | tee -a $filename
done
