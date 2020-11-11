while [ true ]; do
	ps -C simple_switch_grpc -o pcpu,pmem --no-headers | awk '{cpu+=$1; mem+=$2} END {printf("%s,%f,%f\n",systime(),cpu,mem)}';
	sleep 1;
done