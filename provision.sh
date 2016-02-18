#!/bin/sh -e

# Install PostgreSql
APP_DB_USER=db_admin
APP_DB_PASS=db_admin
PG_VERSION=9.5
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

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

# Append to pg_hba.conf to add password auth:
echo "host    all             all             all                     md5" >> "$PG_HBA"
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER $APP_DB_USER WITH SUPERUSER PASSWORD '$APP_DB_PASS';
EOF

service postgresql restart

# Install PGTap
apt-get install -y libtap-parser-sourcehandler-pgtap-perl
wget --quiet https://github.com/theory/pgtap/archive/v0.95.0.tar.gz
tar -zxf v0.95.0.tar.gz
cd pgtap-0.95.0
make && make install
