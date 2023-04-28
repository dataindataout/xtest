#!/bin/bash
# file: up.sh

./initialize.sh

./start_catalog_east.sh
./start_tservers_east.sh

./start_catalog_west.sh
./start_tservers_west.sh

./set_placement_3by2.sh

curl -s http://127.0.0.1:7000/cluster-config
curl -s http://127.0.0.4:7000/cluster-config

echo "waiting for cluster to start up fully the first time, stand by"

sleep 30

./datagen/east/create_milliontable_east.sh
./datagen/west/create_milliontable_west.sh

# ysqlsh -h 127.0.0.1 -c "INSERT INTO milliontable (name, age) SELECT substr(md5(random()::text), 1, 10), (random() * 70 + 10)::integer FROM generate_series(1, 1000000)"

echo "setting up placement definitions, stand by"

sleep 15

./xcluster.sh
