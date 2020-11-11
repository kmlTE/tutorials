#!/usr/bin/env bash

algo_dir=$1
next_dir=$2
algo_id=$3

ts_file=cpu-util.dat
stat_file=cpu-util.csv

# two data files - time series and statistics

for i in $(ls $algo_dir/$next_dir/raw); do

	src_path=$algo_dir/$next_dir/raw/$i
	dst_path=$algo_dir/$next_dir/graphs/cpu-$i/data
	
	mkdir -p $dst_path

	src_file=${src_path}/${stat_file}
	dst_file=${dst_path}/${ts_file}
	
	iperf_time=$(cat $src_file | wc -l)

	echo 0 | nl -b a -v 0 | tee $dst_file
	head -n $iperf_time $src_file | cut -d ',' -f 2 | nl -b a -i 1 -v 1 | tee -a $dst_file

done;

exit;








echo "id,name,min,max,avg,stddev" | tee data/cpu-data.csv

for i in $(ls -v data/cpu-util-*.csv); do
	csv=${i##*/}
	bw=${csv%%.*}
	bw=${bw##*-}
	filename=${i%%.csv}.dat

	echo $i $csv $bw $filename

	id=$((id+1))

	id=$id bw=$bw \
	awk -F "\"*,\"*" '
		{
			sum += $2; 
			sumsq += $2 * $2; 
			avg = 0;
			stddev = 0;
			if (max == "" || $2 + 0 > max) {max = $2};
			if (min == "" || $2 + 0 < min) {min = $2};
		} END {
			avg = sum / NR;
			stddev = sqrt(sumsq / NR - (sum / NR)**2);
			printf("%s\t%s\t%s\t%s\t%s\t%s\n",
				   "id", "name", "min", "max", "avg", "stddev");
			printf("%s\t%s\t%s\t%s\t%s\t%s\n",
				   ENVIRON["id"], ENVIRON["bw"], min, max, avg, stddev);
		}
	' $i | tee $filename

	tail -n 1 $filename | tr "\t" "," | tee -a data/cpu-data.csv

done



# id=0

# echo "id,name,min,max,avg,stddev" | tee data/cpu-data.csv

# for i in $(ls -v data/cpu-util-*.csv); do
# 	csv=${i##*/}
# 	bw=${csv%%.*}
# 	bw=${bw##*-}
# 	filename=${i%%.csv}.dat

# 	echo $i $csv $bw $filename

# 	id=$((id+1))

# 	id=$id bw=$bw \
# 	awk -F "\"*,\"*" '
# 		{
# 			sum += $2; 
# 			sumsq += $2 * $2; 
# 			avg = 0;
# 			stddev = 0;
# 			if (max == "" || $2 + 0 > max) {max = $2};
# 			if (min == "" || $2 + 0 < min) {min = $2};
# 		} END {
# 			avg = sum / NR;
# 			stddev = sqrt(sumsq / NR - (sum / NR)**2);
# 			printf("%s\t%s\t%s\t%s\t%s\t%s\n",
# 				   "id", "name", "min", "max", "avg", "stddev");
# 			printf("%s\t%s\t%s\t%s\t%s\t%s\n",
# 				   ENVIRON["id"], ENVIRON["bw"], min, max, avg, stddev);
# 		}
# 	' $i | tee $filename

# 	tail -n 1 $filename | tr "\t" "," | tee -a data/cpu-data.csv

# done
