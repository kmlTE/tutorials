#!/usr/bin/env bash

algo_dir=$1
next_dir=$2

## tcp retransmissions
export OUTPUT_FILE=${algo_dir}/${next_dir}/graphs/retry/graph.pdf
export YLABEL="TCP Number of retransmissions"
export DATA=${algo_dir}/${next_dir}/graphs/retry/data/h\'.i.\'.dat
export WITH=lines
export EVERY="1"
export LEGEND=top right

cat plot-others.gpl.tmpl | envsubst > plot-others.gpl
gnuplot plot-others.gpl
rm plot-others.gpl

xdg-open $OUTPUT_FILE &

## tcp rtt
export OUTPUT_FILE=${algo_dir}/${next_dir}/graphs/rtt/graph.pdf
export YLABEL="TCP RTT (ms)"
export DATA=${algo_dir}/${next_dir}/graphs/rtt/data/h\'.i.\'.dat
export WITH=lines
export EVERY="1"
export LEGEND=bottom right

cat plot-others.gpl.tmpl | envsubst > plot-others.gpl
gnuplot plot-others.gpl
rm plot-others.gpl

xdg-open $OUTPUT_FILE &

## udp losses
export OUTPUT_FILE=${algo_dir}/${next_dir}/graphs/loss/graph.pdf
export YLABEL="UDP Packet losses (%)"
export DATA=${algo_dir}/${next_dir}/graphs/loss/data/h\'.i.\'.dat
export WITH=lines
export EVERY=1
export LEGEND=top right

cat plot-others.gpl.tmpl | envsubst > plot-others.gpl
gnuplot plot-others.gpl
rm plot-others.gpl

xdg-open $OUTPUT_FILE &

## udp jitter
export OUTPUT_FILE=${algo_dir}/${next_dir}/graphs/jitter/graph.pdf
export YLABEL="UDP Jitter (ms)"
export DATA=${algo_dir}/${next_dir}/graphs/jitter/data/h\'.i.\'.dat
export WITH=lines
export EVERY=1
export LEGEND=bottom right

cat plot-others.gpl.tmpl | envsubst > plot-others.gpl
gnuplot plot-others.gpl
rm plot-others.gpl

xdg-open $OUTPUT_FILE &

## udp avg latency
export OUTPUT_FILE=${algo_dir}/${next_dir}/graphs/lat/graph.pdf
export YLABEL="UDP Average latency (ms)"
export DATA=${algo_dir}/${next_dir}/graphs/lat/data/h\'.i.\'.dat
export WITH=lines
export EVERY=1
export LEGEND=bottom right

cat plot-others.gpl.tmpl | envsubst > plot-others.gpl
gnuplot plot-others.gpl
rm plot-others.gpl

xdg-open $OUTPUT_FILE &
