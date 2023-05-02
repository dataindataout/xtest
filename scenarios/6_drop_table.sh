#!/bin/bash
# file: drop_table.sh

#!/bin/bash
# file: add_table.sh

# get universe IDs and replication name
eastid=$(curl -s http://127.0.0.1:7000/cluster-config | grep cluster_uuid | awk -F '"' '{print $2}')
westid=$(curl -s http://127.0.0.4:7000/cluster-config | grep cluster_uuid | awk -F '"' '{print $2}')
replication_name="milliontable"

# stop replication
yb-admin --master_addresses 127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 set_universe_replication_enabled $westid"_"$replication_name 0
yb-admin --master_addresses 127.0.0.4:7100,127.0.0.5:7100,127.0.0.6:7100 set_universe_replication_enabled $eastid"_"$replication_name 0

# drop table on both sides
ysqlsh -h 127.0.0.1 -c "drop table if exists table2"
ysqlsh -h 127.0.0.4 -c "drop table if exists table2"

# destroy mytable2 replication configuration
tableid=$(yb-admin \
    --master_addresses 127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 \
    list_tables include_table_id | grep mytable2 | awk -F ' ' '{print $2}')
replication_name="mytable2"

yb-admin \
  --master_addresses 127.0.0.4:7100,127.0.0.5:7100,127.0.0.6:7100 \
  delete_universe_replication $eastid"_"$replication_name \
    127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 \
    $tableid

yb-admin \
  --master_addresses 127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 \
  delete_universe_replication $westid"_"$replication_name \
    127.0.0.4:7100,127.0.0.5:7100,127.0.0.6:7100 \
    $tableid

# add a row to other table to ensure replication is still working for it
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
echo "now run \dt on both to ensure table was dropped"