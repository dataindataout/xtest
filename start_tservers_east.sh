#!/bin/bash
# file: start_tservers.sh
# Run YB-TServer with configuration file

yb-tserver --flagfile=./conf/tserver/east/tserver1.conf >& /tmp/data1/yb-tserver.out &
yb-tserver --flagfile=./conf/tserver/east/tserver2.conf >& /tmp/data2/yb-tserver.out &
yb-tserver --flagfile=./conf/tserver/east/tserver3.conf >& /tmp/data3/yb-tserver.out &
