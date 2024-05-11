#!/usr/bin/bash
#
# show_tc.bash
#

read _ _ _ _ INTERFACE _ < <(ip route list match 0/0)

tc -p -s -d qdisc show dev "${INTERFACE}"
tc -p -s -d qdisc show dev ifb0
# end