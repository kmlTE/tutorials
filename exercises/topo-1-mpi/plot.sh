#!/usr/bin/env bash

algo_dir=$1
next_dir=$2

## tcp cpu
export OUTPUT_FILE=${algo_dir}/${next_dir}/graphs/cpu-tcp/graph.pdf
export YLABEL="CPU Utilization (%)"
export DATA=${algo_dir}/${next_dir}/graphs/cpu-tcp/data/cpu-util.dat

cat plot-cpu-ts.gpl.tmpl | envsubst > plot.gpl
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
