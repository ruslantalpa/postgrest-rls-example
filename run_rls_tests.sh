#!/bin/sh -e

sudo -u postgres pg_prove -d app tests/rls/*.sql
