#!/bin/bash
# file: set_placement.sh
# Set replica placement policy for 3-region cluster

yb-admin \
    --master_addresses 127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 \
    modify_placement_info \
    gcp.us-east1.us-east1-a,gcp.us-east2.us-east2-a,gcp.us-east3.us-east3-a 3