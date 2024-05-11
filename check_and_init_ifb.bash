#!/usr/bin/bash
#
# check_and_init_ifb.bash
#
# check ifb exists, and create it if it doesn't
#
# https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking#ifb

if [ "$EUID" -ne 0 ]
then
	echo "Please run as root"
	exit 1
fi

echo "checking for ifb0"

ip link show dev ifb0; exit_status=$?

if [ $exit_status -eq 1 ]; then

	echo "creating ifb0"

	read _ _ _ _ INTERFACE _ < <(ip route list match 0/0)

	ip link add ifb0 type ifb
	ip link set ifb0 up

	tc qdisc add dev "${INTERFACE}" handle ffff: ingress
	tc filter add dev "${INTERFACE}" parent ffff: u32 match u32 0 0 action mirred egress redirect dev ifb0

	ip link show dev ifb0
else
	echo "ifb0 exists"
fi
# end
