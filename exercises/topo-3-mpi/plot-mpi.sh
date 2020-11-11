#!/usr/bin/env bash

algo_dir=$1
next_dir=single/graphs/$2

## tcp mpi
export OUTPUT_FILE=graphs/$2/graph.pdf
export YLABEL="Average ping-pong latency (μs)"
export DATA_DEF=def/${next_dir}/data/mpi.dat
export DATA_STRICT=strict/${next_dir}/data/mpi.dat
export DATA_DRR=drr/${next_dir}/data/mpi.dat

cat plot-mpi.gpl.tmpl | envsubst > plot-mpi.gpl
gnuplot plot-mpi.gpl
rm plot-mpi.gpl

xdg-open $OUTPUT_FILE &