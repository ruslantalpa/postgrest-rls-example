#!/bin/sh -e

# Install PostgreSql
# Edit the following to change the version of PostgreSQL that is installed
PG_VERSION=9.5


PG_REPO_APT_SOURCE=/etc/apt/sources.list.d/pgdg.list
if [ ! -f "$PG_REPO_APT_SOURCE" ]
then
  # Add PG apt repo:
  echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.5" > "$PG_REPO_APT_SOURCE"

  # Add PGDG repo key:
  wget --quiet -O - https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
fi

apt-get update
apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION" "postgresql-server-dev-$PG_VERSION"



# Install PGTap
apt-get install -y libtap-parser-sourcehandler-pgtap-perl
wget --quiet https://github.com/theory/pgtap/archive/v0.95.0.tar.gz
tar -zxf v0.95.0.tar.gz
cd pgtap-0.95.0
make && make install
