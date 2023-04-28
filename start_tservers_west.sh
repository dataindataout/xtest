#!/bin/bash
# file: start_tservers.sh
# Run YB-TServer with configuration file

yb-tserver --flagfile=./conf/tserver/west/tserver4.conf >& /tmp/data1/yb-tserver.out &
yb-tserver --flagfile=./conf/tserver/west/tserver5.conf >& /tmp/data2/yb-tserver.out &
yb-tserver --flagfile=./conf/tserver/west/tserver6.conf >& /tmp/data3/yb-tserver.out &
