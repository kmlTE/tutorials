#!/usr/bin/env bash

for i in def strict drr; do

    ./dump-others.sh $i toggle 270
    ./plot-others.sh $i toggle

done;
