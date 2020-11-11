#!/usr/bin/env bash

algo_dir=$1
next_dir=$2

## tcp bandwidth
export OUTPUT_FILE=${algo_dir}/${next_dir}/graphs/bw-tcp/graph.pdf
export YLABEL="TCP Bandwidth (Mbps)"
export DATA=${algo_dir}/${next_dir}/graphs/bw-tcp/data/h\'.i.\'.dat

cat plot.gpl.tmpl | envsubst > plot.gpl
gnuplot plot.gpl
rm plot.gpl

xdg-open $OUTPUT_FILE &


## tcp cpu
export OUTPUT_FILE=${algo_dir}/${next_dir}/graphs/cpu-tcp/graph.pdf
export YLABEL="CPU Utilization (%)"
export DATA=${algo_dir}/${next_dir}/graphs/cpu-tcp/data/cpu-util.dat

cat plot-cpu-ts.gpl.tmpl | envsubst > plot.gpl
gnuplot plot.gpl
rm plot.gpl

xdg-open $OUTPUT_FILE &


## udp bandwidth
export OUTPUT_FILE=${algo_dir}/${next_dir}/graphs/bw-udp/graph.pdf
export YLABEL="UDP Bandwidth (Mbps)"
export DATA=${algo_dir}/${next_dir}/graphs/bw-udp/data/h\'.i.\'.dat

cat plot.gpl.tmpl | envsubst > plot.gpl
gnuplot plot.gpl
rm plot.gpl

xdg-open $OUTPUT_FILE &


## udp cpu
export OUTPUT_FILE=${algo_dir}/${next_dir}/graphs/cpu-udp/graph.pdf
export YLABEL="CPU Utilization (%)"
export DATA=${algo_dir}/${next_dir}/graphs/cpu-udp/data/cpu-util.dat

cat plot-cpu-ts.gpl.tmpl | envsubst > plot.gpl
gnuplot plot.gpl
rm plot.gpl

xdg-open $OUTPUT_FILE &