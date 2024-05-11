#!/usr/bin/bash
#
# sim.bash
#
# 1. checks if the ifb is created, and will create it if it does not exist
# 2. checks the /etc/sysctl.conf is correct, and will update it if it isn't
# 3. updates the latency injection

log(){
	date --u +"%Y_%m_%d_%H:%M:%S.%N ${0##*/} $1"
}

DELAY=$1

if [ "$EUID" -ne 0 ]
then
	echo "Please run as root"
	exit 1
fi

if [[ $DELAY != *ms* ]]
then
    echo "Please supply argument in milliseconds.  eg. ./sim.bash 50ms"
    exit 1
fi

./check_and_init_ifb.bash
./check_sysctls_and_fix.bash

echo "----------------------"
echo "-- BEFORE"

./show_tc.bash

echo "----------------------"

read _ _ _ _ INTERFACE _ < <(ip route list match 0/0)

log "tc qdisc replace dev ifb0 root netem limit 100000 delay ${DELAY}"
tc qdisc replace dev ifb0 root netem limit 100000 delay "${DELAY}"

log "tc qdisc replace dev ${INTERFACE} root netem limit 100000 delay ${DELAY}"
tc qdisc replace dev "${INTERFACE}" root netem limit 100000 delay "${DELAY}"

echo "----------------------"
echo "-- AFTER"

./show_tc.bash

# end
