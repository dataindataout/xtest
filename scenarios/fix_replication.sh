#!/bin/bash
# file: fix_replication.sh


# todo: something else here to fix replication
# hoping to skip errors and resume replication
# nope

# reset

./down.sh
./upx.sh
./scenarios/1_running_traffic.sh