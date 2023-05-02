#!/bin/bash
# file: add_index.sh

# you don't have to pause replication for this one
# so I'm not doing that here, as an example

# add index on both sides
ysqlsh -h 127.0.0.1 -c "create index if not exists idx_age on milliontable(age)"
ysqlsh -h 127.0.0.4 -c "create index if not exists idx_age on milliontable(age)"

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
echo "now run \d+ milliontable on both to ensure index was added"