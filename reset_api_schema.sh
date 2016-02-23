#!/bin/sh -e
cd ./sql
sudo -u postgres psql -d app -f ./api_schema.sql