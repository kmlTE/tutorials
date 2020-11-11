#!/usr/bin/env bash

set -x

TOPO=topo-1
TOPO_DESCR="TOPO-1: simple star"

export ROOT_DIR=$(pwd)

export LINK_CAP_MB=100
export LINK_RATE=$(( $LINK_CAP_MB * 125000 )) # 125000 = LINK_CAP_MB / 8
export HALF_LINK_RATE_MB=$(( $LINK_CAP_MB / 2 ))
export FAIR_RATE=$(( $LINK_RATE / 3 ))

export IPERF_INTERVAL=600

algos=( "simple_switch" "simple_switch_sp_bytes_dp_rate" "simple_switch_rl_sp_drr_orig" )
algo_dirs=( "def" "strict" "drr" )


compile_target () {

	local target=$ALGO_TARGET

	sed -i "s/SS_TARGET_PATH = [a-z_][a-z_]*/SS_TARGET_PATH = ${target}/g" ~/p4/p4-install/behavioral-model/targets/simple_switch_grpc/Makefile.am

	cd ~/p4/p4-install/
	./compile_targets.sh grpc
	cd ${ROOT_DIR}
}

setup_dirs () {

	mkdir -p ${ALGO_DIR}/single/
	cd ${ALGO_DIR}/single/

	mkdir -p raw/tcp raw/udp
	mkdir -p graphs/bw-tcp/data graphs/bw-udp/data graphs/rtt/data graphs/loss/data graphs/lat/data graphs/cpu-tcp/data graphs/cpu-udp/data

	cd ${ROOT_DIR}
}

# SINGLE
iperf_single () {

	# TCP
	export IPERF_TIME=$IPERF_INTERVAL
	export PREFIX=${ROOT_DIR}/${ALGO_DIR}/single/raw/tcp
	export UDP_FLAG=""
	export UDP_ARGS=""

	run_single
	
	# UDP
	export PREFIX=${ROOT_DIR}/${ALGO_DIR}/single/raw/udp
	export UDP_FLAG="-u"
	export UDP_ARGS="-u -b ${HALF_LINK_RATE_MB}M"

	run_single
}

run_single () {

	cat run_iperf_single.tmpl | envsubst > ../run_iperf
	cat topology.json.tmpl | envsubst > topology.json
	cat s1-runtime.json.tmpl | envsubst > s1-runtime.json

	make clean && make run && make clean

	rm ../run_iperf topology.json s1-runtime.json
}


###############################################################################
###############################################################################

echo "*******************************"
echo "SETUP GENERATOR FOR $TOPO_DESCR"
echo "*******************************"



# DEF SETUP
setup_def () {

	export ALGO_DIR="def"
	export ALGO_TARGET="simple_switch"
	export ALGO_ID=1
	setup_dirs $ALGO_DIR
	compile_target
}

# RUN IPERF DEF
iperf_def () {

	export HP_RATE=$(( $LINK_CAP_MB * 75000 )) # $LINK_CAP_MB * 75000 = 0.6 * LINK_RATE
	export LP_RATE=$(( $LINK_CAP_MB * 25000 )) # $LINK_CAP_MB * 25000 = 0.2 * LINK_RATE
	export HP_QUEUE=7
	iperf_single
}


# SP SETUP
setup_strict () {

	export ALGO_DIR="strict"
	export ALGO_TARGET="simple_switch_sp_bytes_dp_rate"
	export ALGO_ID=2
	setup_dirs $ALGO_DIR
	compile_target
}

# RUN IPERF SP
iperf_strict () {

	export HP_RATE=$(( $LINK_CAP_MB * 75000 )) # $LINK_CAP_MB * 75000 = 0.6 * LINK_RATE
	export LP_RATE=$(( $LINK_CAP_MB * 25000 )) # $LINK_CAP_MB * 25000 = 0.2 * LINK_RATE
	export HP_QUEUE=7
	iperf_single
}


# DRR SETUP
setup_drr () {

	export ALGO_DIR="drr"
	export ALGO_TARGET="simple_switch_rl_sp_drr_orig"
	export ALGO_ID=3
	setup_dirs $ALGO_DIR
	compile_target
}

# RUN IPERF DRR
iperf_drr () {

	export HP_RATE=$(( $LINK_CAP_MB * 75000 )) # $LINK_CAP_MB * 75000 = 0.6 * LINK_RATE
	export LP_RATE=$(( $LINK_CAP_MB * 25000 )) # $LINK_CAP_MB * 25000 = 0.2 * LINK_RATE
	export HP_QUEUE=7
	iperf_single
}




echo "**************"
echo "PERFORMING DEF"
echo "**************"
setup_def
iperf_def


echo "*************"
echo "PERFORMING SP"
echo "*************"
setup_strict
iperf_strict


echo "**************"
echo "PERFORMING DRR"
echo "**************"
setup_drr
iperf_drr
