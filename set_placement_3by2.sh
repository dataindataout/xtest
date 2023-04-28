#!/bin/bash
# file: set_placement_3by2.sh
# Set replica placement policy in preparation for xcluster

# this says "gcp" as an example; does not actually deploy to the cloud

yb-admin \
    --master_addresses 127.0.0.1:7100,127.0.0.2:7100,127.0.0.3:7100 \
    modify_placement_info \
    gcp.us-east1.us-east1-a,gcp.us-east2.us-east2-a,gcp.us-east3.us-east3-a 3

yb-admin \
    --master_addresses 127.0.0.4:7100,127.0.0.5:7100,127.0.0.6:7100 \
    modify_placement_info \
    gcp.us-west1.us-west1-a,gcp.us-west2.us-west2-a,gcp.us-west3.us-west3-a 3