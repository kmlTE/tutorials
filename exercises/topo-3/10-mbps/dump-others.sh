#!/usr/bin/env bash

algo_dir=$1
next_dir=$2
iperf_time=$3

## tcp retransmissions
for i in $(seq 1 3); do
    suffix=h${i}
    mkdir -p ${algo_dir}/${next_dir}/graphs/retry/data
    filename=${algo_dir}/${next_dir}/graphs/retry/data/${suffix}.dat
    echo $filename
    echo 0 | nl -b a -v 0 | tee $filename
    cat ${algo_dir}/${next_dir}/raw/tcp/h${i}-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 11 | nl -b a -i 1 -v 1 | tee -a $filename
done

## tcp rtt
for i in $(seq 1 3); do
    suffix=h${i}
    mkdir -p ${algo_dir}/${next_dir}/graphs/rtt/data
    filename=${algo_dir}/${next_dir}/graphs/rtt/data/${suffix}.dat
    echo $filename
    echo 0 | nl -b a -v 0 | tee $filename
    cat ${algo_dir}/${next_dir}/raw/tcp/h${i}-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 10 | nl -b a -i 1 -v 1 | tee -a $filename
done


## udp packet loss
for i in $(seq 1 3); do
    suffix=h${i}
    mkdir -p ${algo_dir}/${next_dir}/graphs/loss/data
    filename=${algo_dir}/${next_dir}/graphs/loss/data/${suffix}.dat
    echo $filename
    echo 0 | nl -b a -v 0 | tee $filename
    cat ${algo_dir}/${next_dir}/raw/udp/h$(( $i+6 ))-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 13 | nl -b a -i 1 -v 1 | tee -a $filename
done


## udp jitter
for i in $(seq 1 3); do
    suffix=h${i}
    mkdir -p ${algo_dir}/${next_dir}/graphs/jitter/data
    filename=${algo_dir}/${next_dir}/graphs/jitter/data/${suffix}.dat
    echo $filename
    echo 0 | nl -b a -v 0 | tee $filename
    cat ${algo_dir}/${next_dir}/raw/udp/h$(( $i+6 ))-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 10 | nl -b a -i 1 -v 1 | tee -a $filename
done


## udp avg latency
for i in $(seq 1 3); do
    suffix=h${i}
    mkdir -p ${algo_dir}/${next_dir}/graphs/lat/data
    filename=${algo_dir}/${next_dir}/graphs/lat/data/${suffix}.dat
    echo $filename
    echo 0 | nl -b a -v 0 | tee $filename
    cat ${algo_dir}/${next_dir}/raw/udp/h$(( $i+6 ))-iperf.csv | grep -v "0.0-${iperf_time}" | grep ",10.0.1.${i}," | cut -d ',' -f 15 | nl -b a -i 1 -v 1 | tee -a $filename
done