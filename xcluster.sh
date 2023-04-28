#!/bin/bash
# file: xcluster.sh

eastid=$(curl -s http://127.0.0.1:7000/cluster-config | grep cluster_uuid | awk -F '"' '{print $2}')
westid=$(curl -s http://127.0.0.4:7000/cluster-config | grep cluster_uuid | awk -F '"' '{print $2}')

tableid=$(yb-admin \
    --master_addresses 127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 \
    list_tables include_table_id | grep milliontable | awk -F ' ' '{print $2}')
replication_name="milliontable"

yb-admin \
  --master_addresses 127.0.0.4:7100,127.0.0.5:7100,127.0.0.6:7100 \
  setup_universe_replication $eastid"_"$replication_name \
    127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 \
    $tableid

yb-admin \
  --master_addresses 127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 \
  setup_universe_replication $westid"_"$replication_name \
    127.0.0.4:7100,127.0.0.5:7100,127.0.0.6:7100 \
    $tableid
