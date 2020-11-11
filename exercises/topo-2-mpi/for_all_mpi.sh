#!/usr/bin/env bash

for i in $(ls */*/*/*/h1-mpi.csv); do
    algo=$(echo $i | cut -d "/" -f 1)
    transport=$(echo $i | cut -d "/" -f 4)

    echo ${algo} mpi-${transport}

    ./dump_mpi.sh $i $algo mpi-${transport}
    
done

for i in $(ls */*/*/*/h1-mpi.csv); do
    transport=$(echo $i | cut -d "/" -f 4)

    echo ${algo} mpi-${transport}

    ./plot-mpi.sh $algo mpi-${transport}
    
done
