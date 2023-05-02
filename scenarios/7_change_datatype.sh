#!/bin/bash
# file: change_datatype.sh

# you don't have to stop replication for this one
# so I'm not doing that here, as an example

# alter datatype on both sides
ysqlsh -h 127.0.0.1 -c "alter table milliontable alter column name type varchar(25)"
ysqlsh -h 127.0.0.4 -c "alter table milliontable alter column name type varchar(25)"

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
yb-admin --master_addresses 127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 get_replication_status
yb-admin --master_addresses 127.0.0.4:7100,127.0.0.5:7100,127.0.0.6:7100 get_replication_status

# verify
echo "now run \d+ milliontable on both to ensure datatype was changed from varchar(10) to varchar(25)"