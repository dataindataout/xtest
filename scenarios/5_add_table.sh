#!/bin/bash
# file: add_table.sh

# get universe IDs and replication name
eastid=$(curl -s http://127.0.0.1:7000/cluster-config | grep cluster_uuid | awk -F '"' '{print $2}')
westid=$(curl -s http://127.0.0.4:7000/cluster-config | grep cluster_uuid | awk -F '"' '{print $2}')
replication_name="milliontable"

# stop replication
yb-admin --master_addresses 127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 set_universe_replication_enabled $westid"_"$replication_name 0
yb-admin --master_addresses 127.0.0.4:7100,127.0.0.5:7100,127.0.0.6:7100 set_universe_replication_enabled $eastid"_"$replication_name 0

# add table on both sides
ysqlsh -h 127.0.0.1 -c "create table  if not exists table2 (name varchar(10), age integer)"
ysqlsh -h 127.0.0.4 -c "create table  if not exists table2 (name varchar(10), age integer)"

# start replication
yb-admin --master_addresses 127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 set_universe_replication_enabled $westid"_"$replication_name 1
yb-admin --master_addresses 127.0.0.4:7100,127.0.0.5:7100,127.0.0.6:7100 set_universe_replication_enabled $eastid"_"$replication_name 1

# add a row
ysqlsh -h 127.0.0.1 -c "INSERT INTO milliontable (name, age) SELECT substr(md5(random()::text), 1, 10), (random() * 70 + 10)::integer"

# count the rows on both sides
echo "eastside:"
ysqlsh -h 127.0.0.1 -c "select count(*) from milliontable"
echo "westside:"
ysqlsh -h 127.0.0.4 -c "select count(*) from milliontable"

# check replication
echo "replication status:"
curl "http://127.0.0.1:9000/prometheus-metrics" --silent | grep async_replication
yb-admin --master_addresses 127.0.0.4:7100,127.0.0.5:7100,127.0.0.6:7100 get_replication_status

# verify
echo "now run \dt on both to ensure table was added"