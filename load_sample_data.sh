#!/bin/sh -e
cd ./sql
sudo -u postgres psql -f ./big_sample_dataset.sql