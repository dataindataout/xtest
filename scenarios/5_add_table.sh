#!/bin/bash
# file: add_table.sh

# get universe IDs and replication name
eastid=$(curl -s http://127.0.0.1:7000/cluster-config | grep cluster_uuid | awk -F '"' '{print $2}')
westid=$(curl -s http://127.0.0.4:7000/cluster-config | grep cluster_uuid | awk -F '"' '{print $2}')
replication_name="milliontable"

# add a table on both sides
ysqlsh -h 127.0.0.1 -c "create table  if not exists table2 (name varchar(10), age integer)"
ysqlsh -h 127.0.0.4 -c "create table  if not exists table2 (name varchar(10), age integer)"

# set up replication for this table

# add a row to the table

# count the rows on both sides
echo "eastside:"
ysqlsh -h 127.0.0.1 -c "select count(*) from table2"
echo "westside:"
ysqlsh -h 127.0.0.4 -c "select count(*) from table2"

# check replication
echo "replication status:"
curl "http://127.0.0.1:9000/prometheus-metrics" --silent | grep async_replication
yb-admin --master_addresses 127.0.0.4:7100,127.0.0.5:7100,127.0.0.6:7100 get_replication_status

# verify
echo "now run \dt on both to ensure table was added"