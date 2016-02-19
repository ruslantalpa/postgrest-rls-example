#!/bin/sh -e

sudo -u postgres pg_prove --verbose -d app tests/performance/*.sql
