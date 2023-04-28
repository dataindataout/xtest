#!/bin/bash
# file: start_catalog.sh
# Run YB-Master servers with configuration file5
yb-master --flagfile=./conf/catalog/west/catalog4.conf >& /tmp/data1/yb-catalog.out &
yb-master --flagfile=./conf/catalog/west/catalog5.conf >& /tmp/data2/yb-catalog.out &
yb-master --flagfile=./conf/catalog/west/catalog6.conf >& /tmp/data3/yb-catalog.out &
