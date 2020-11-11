#!/usr/bin/env bash

datafile=$1
algo=$2
next=$3
filename=${algo}/single/graphs/${next}/data/mpi.dat

mkdir -p graphs/${next}
mkdir -p $(dirname $filename)

awk -F "\"*,\"*" '
  NR%2 { split($0, a) ; next }
  { printf "%d,%f\n", a[1], a[2]+$2}
' $datafile > tmpfile

id=0

printf "%s,%s,%s,%s,%s,%s\n" \
       "id" "name" "min" "max" "avg" "stddev" | tee $filename

for i in $(seq 0 14); do

    id=$((id + 1))
    msg=$(echo "2^$i" | bc)

	id=$id msg=$msg awk -F "\"*,\"*" '
    $1==ENVIRON["msg"] {
        sum += $2; 
        sumsq += $2 * $2; 
        avg = 0;
        stddev = 0;
        if (max == "" || $2 + 0 > max) {max = $2};
        if (min == "" || $2 + 0 < min) {min = $2};
        cnt+=1;
    } END {
        avg = sum / cnt;
        stddev = sqrt(sumsq / cnt - (sum / cnt)**2);
        printf("%s,%s,%s,%s,%s,%s\n",
               ENVIRON["id"], ENVIRON["msg"], min, max, avg, stddev);
    }
    ' tmpfile | tee -a $filename

done;

rm tmpfile
