#!/bin/sh -e
cd ./sql
sudo -u postgres psql -f ./sample_data.sql