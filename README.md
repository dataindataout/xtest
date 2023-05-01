# basics

- to start a test xcluster, run upx.sh
- to destroy a test cluster and all files and processes, run down.sh

# prereqs

- a copy of yugabytedb
- set your path to include the bin folder within the yugabytedb directory
- set local ips for 6 nodes via set_ips.sh (127.0.01 - 127.0.0.6)

# assumptions

- this works on mac apple m1, may or may not work on other OS
- current scenarios assume version 2.17 (see other branches for previous versions)
- you should be using 2.17+ for xcluster
- placement says "gcp" as an example; does not actually deploy to gcp

# xcluster scenarios

to run scenarios, see the scenarios folder:

- 1_running_traffic.sh (adds a million rows)
- 2_add_index.sh
- 3_add_column.sh
- 4_drop_column.sh
- 5_add_table.sh
- 6_drop_table.sh
- 7_change_datatype.sh

# visual representation

basic UI at:

<http://127.0.0.1:7000>

<http://127.0.0.4:7000>

# other

comments and dragons within
