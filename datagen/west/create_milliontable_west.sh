#!/bin/bash
# file: populate_data.sh
# create table 

ysqlsh -h 127.0.0.4 -c "create table milliontable(name varchar(10), age integer)"