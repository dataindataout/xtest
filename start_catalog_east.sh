#!/bin/bash
# file: start_catalog.sh
# Run YB-Master servers with configuration file

yb-master --flagfile=./conf/catalog/east/catalog1.conf >& /tmp/data1/yb-catalog.out &
yb-master --flagfile=./conf/catalog/east/catalog2.conf >& /tmp/data2/yb-catalog.out &
yb-master --flagfile=./conf/catalog/east/catalog3.conf >& /tmp/data3/yb-catalog.out &
