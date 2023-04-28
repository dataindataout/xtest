#!/bin/bash
# file: up.sh

./initialize.sh

./start_catalog_east.sh
./start_tservers_east.sh
./set_placement_3region.sh

curl -s http://127.0.0.1:7000/cluster-config