#!/usr/bin/env bash

set -x

TOPO=topo-1
TOPO_DESCR="TOPO-1: simple star"

export ROOT_DIR=$(pwd)

export LINK_CAP_MB=100
export LINK_RATE=$(( $LINK_CAP_MB * 125000 )) # 125000 = LINK_CAP_MB / 8
export HALF_LINK_RATE_MB=$(( $LINK_CAP_MB / 2 ))
export FAIR_RATE=$(( $LINK_RATE / 3 ))

export IPERF_INTERVAL=90

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

	mkdir -p ${ALGO_DIR}/toggle/
	cd ${ALGO_DIR}/toggle/

	mkdir -p raw/tcp raw/udp
	mkdir -p graphs/bw-tcp/data graphs/bw-udp/data graphs/rtt/data graphs/loss/data graphs/lat/data graphs/cpu-tcp/data graphs/cpu-udp/data

	cd ${ROOT_DIR}
}

# TOGGLE
iperf_toggle () {

	# TCP
	export IPERF_TIME=$(( $IPERF_INTERVAL * 3 ))
	export PREFIX=${ROOT_DIR}/${ALGO_DIR}/toggle/raw/tcp
	export TARGET=$ALGO_TARGET
	export UDP_FLAG=""
	export UDP_ARGS=""

	run_toggle

	# UDP
	export IPERF_TIME=$(( $IPERF_INTERVAL * 3 ))
	export PREFIX=${ROOT_DIR}/${ALGO_DIR}/toggle/raw/udp
	export TARGET=$ALGO_TARGET
	export UDP_FLAG="-u"
	export UDP_ARGS="-u -b ${HALF_LINK_RATE_MB}M"

	run_toggle

	compose_graphs "toggle"
}

run_toggle () {

	cat run_iperf_toggle.tmpl | envsubst > ../run_iperf
	cat topology.json.tmpl | envsubst > topology.json
	cat s1-runtime.json.tmpl | envsubst > s1-runtime.json

	make clean && make run && make clean

	rm ../run_iperf topology.json s1-runtime.json
}

compose_graphs () {

	local next_dir=$1

	./from_csv_to_dat.sh $ALGO_DIR $next_dir $IPERF_TIME $ALGO_ID
	./cpu_util.sh $ALGO_DIR $next_dir $IPERF_TIME $ALGO_ID

	./plot.sh $ALGO_DIR $next_dir
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
	export LP_RATE=$(( $HALF_LINK_RATE_MB * 125000 )) # $LINK_CAP_MB * 25000 = 0.2 * LINK_RATE
	export HP_QUEUE=7
	iperf_toggle
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
	export LP_RATE=$(( $HALF_LINK_RATE_MB * 125000 )) # $HALF_LINK_RATE_MB * 125000 = 0.5 * LINK_RATE
	export HP_QUEUE=7
	iperf_toggle
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
	export LP_RATE=$(( $HALF_LINK_RATE_MB * 125000 )) # $HALF_LINK_RATE_MB * 125000 = 0.5 * LINK_RATE
	export HP_QUEUE=7
	iperf_toggle
}


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

echo "**************"
echo "PERFORMING DEF"
echo "**************"
setup_def
iperf_def
