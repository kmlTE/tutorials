#!/usr/bin/env bash

export DATA_FILE=data/cpu-data.csv
export OUTPUT_FILE=cpu-util.pdf

gnuplot plot-cpu.gpl

xdg-open $OUTPUT_FILE &
