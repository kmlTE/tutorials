#!/usr/bin/env bash

algo_dir=$1
next_dir=$2
iperf_time=$3
iperf_period=$(( $iperf_time / 3 ))

## tcp retransmissions
suffix=h1
filename=${algo_dir}/${next_dir}/graphs/retry/data/${suffix}.dat
mkdir -p ${algo_dir}/${next_dir}/graphs/retry/data
echo $filename
yes "0" | head -n $(( $iperf_period + 1 )) | nl -b a -v 0 | tee $filename
cat ${algo_dir}/${next_dir}/raw/tcp/h1-iperf.csv | grep -v "0.0-${iperf_period}" | grep ",10.0.1.1," | cut -d ',' -f 11 | nl -b a -i 1 -v $(( $iperf_period + 1 )) | tee -a $filename
yes "0" | head -n $iperf_period | nl -b a -v $(( $iperf_period * 2 + 1 )) | tee -a $filename

for i in $(seq 2 3); do
    suffix=h${i}
    filename=${algo_dir}/${next_dir}/graphs/retry/data/${suffix}.dat
    echo $filename
    echo 0 | nl -b a -v 0 | tee $filename
    cat ${algo_dir}/${next_dir}/raw/tcp/h${i}-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 11 | nl -b a -i 1 -v 1 | tee -a $filename
done


## tcp rtt
suffix=h1
filename=${algo_dir}/${next_dir}/graphs/rtt/data/${suffix}.dat
mkdir -p ${algo_dir}/${next_dir}/graphs/rtt/data
echo $filename
yes "0" | head -n $(( $iperf_period + 1 )) | nl -b a -v 0 | tee $filename
cat ${algo_dir}/${next_dir}/raw/tcp/h1-iperf.csv | grep -v "0.0-${iperf_period}" | grep ",10.0.1.1," | cut -d ',' -f 10 | nl -b a -i 1 -v $(( $iperf_period + 1 )) | tee -a $filename
yes "0" | head -n $iperf_period | nl -b a -v $(( $iperf_period * 2 + 1 )) | tee -a $filename

for i in $(seq 2 3); do
    suffix=h${i}
    filename=${algo_dir}/${next_dir}/graphs/rtt/data/${suffix}.dat
    echo $filename
    echo 0 | nl -b a -v 0 | tee $filename
    cat ${algo_dir}/${next_dir}/raw/tcp/h${i}-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 10 | nl -b a -i 1 -v 1 | tee -a $filename
done

## udp packet loss
suffix=h1
filename=${algo_dir}/${next_dir}/graphs/loss/data/${suffix}.dat
mkdir -p ${algo_dir}/${next_dir}/graphs/loss/data
echo $filename
yes "0" | head -n $(( $iperf_period + 1 )) | nl -b a -v 0 | tee $filename
cat ${algo_dir}/${next_dir}/raw/udp/h4-iperf.csv | grep -v "0.0-${iperf_period}" | grep ",10.0.1.1," | cut -d ',' -f 13 | nl -b a -i 1 -v $(( $iperf_period + 1 )) | tee -a $filename
yes "0" | head -n $iperf_period | nl -b a -v $(( $iperf_period * 2 + 1 )) | tee -a $filename

for i in $(seq 2 3); do
    suffix=h${i}
    filename=${algo_dir}/${next_dir}/graphs/loss/data/${suffix}.dat
    echo $filename
    echo 0 | nl -b a -v 0 | tee $filename
    cat ${algo_dir}/${next_dir}/raw/udp/h$(( $i+3 ))-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 13 | nl -b a -i 1 -v 1 | tee -a $filename
done


## udp jitter
suffix=h1
filename=${algo_dir}/${next_dir}/graphs/jitter/data/${suffix}.dat
mkdir -p ${algo_dir}/${next_dir}/graphs/jitter/data
echo $filename
yes "0" | head -n $(( $iperf_period + 1 )) | nl -b a -v 0 | tee $filename
cat ${algo_dir}/${next_dir}/raw/udp/h4-iperf.csv | grep -v "0.0-${iperf_period}" | grep ",10.0.1.1," | cut -d ',' -f 10 | nl -b a -i 1 -v $(( $iperf_period + 1 )) | tee -a $filename
yes "0" | head -n $iperf_period | nl -b a -v $(( $iperf_period * 2 + 1 )) | tee -a $filename

for i in $(seq 2 3); do
    suffix=h${i}
    filename=${algo_dir}/${next_dir}/graphs/jitter/data/${suffix}.dat
    echo $filename
    echo 0 | nl -b a -v 0 | tee $filename
    cat ${algo_dir}/${next_dir}/raw/udp/h$(( $i+3 ))-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 10 | nl -b a -i 1 -v 1 | tee -a $filename
done


## udp avg latency
suffix=h1
filename=${algo_dir}/${next_dir}/graphs/lat/data/${suffix}.dat
mkdir -p ${algo_dir}/${next_dir}/graphs/lat/data
echo $filename
yes "0" | head -n $(( $iperf_period + 1 )) | nl -b a -v 0 | tee $filename
cat ${algo_dir}/${next_dir}/raw/udp/h4-iperf.csv | grep -v "0.0-${iperf_period}" | grep ",10.0.1.1," | cut -d ',' -f 15 | nl -b a -i 1 -v $(( $iperf_period + 1 )) | tee -a $filename
yes "0" | head -n $iperf_period | nl -b a -v $(( $iperf_period * 2 + 1 )) | tee -a $filename

for i in $(seq 2 3); do
    suffix=h${i}
    filename=${algo_dir}/${next_dir}/graphs/lat/data/${suffix}.dat
    echo $filename
    echo 0 | nl -b a -v 0 | tee $filename
    cat ${algo_dir}/${next_dir}/raw/udp/h$(( $i+3 ))-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 15 | nl -b a -i 1 -v 1 | tee -a $filename
done