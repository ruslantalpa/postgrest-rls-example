#!/bin/sh -e
cd ./sql
sudo -u postgres psql -f ./main.sql