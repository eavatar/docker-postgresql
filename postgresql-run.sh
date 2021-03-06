#!/bin/bash

exec 2>&1
source /etc/envvars

set -e

PG_VERSION="9.4"
PG_CONFDIR="/etc/postgresql/${PG_VERSION}/main"
PG_BINDIR="/usr/lib/postgresql/${PG_VERSION}/bin"
PG_DATADIR="/var/lib/postgresql/${PG_VERSION}/main"

DB_NAME=${DB_NAME:-}
DB_USER=${DB_USER:-}
DB_PASS=${DB_PASS:-}

chown -R postgres:postgres /etc/postgresql

# fix permissions and ownership of /var/lib/postgresql
mkdir -p -m 0700 /var/lib/postgresql
chown -R postgres:postgres /var/lib/postgresql

# fix permissions and ownership of /run/postgresql
mkdir -p -m 0755 /var/run/postgresql /var/run/postgresql/${PG_VERSION}-main.pg_stat_tmp
chown -R postgres:postgres /var/run/postgresql
chmod g+s /var/run/postgresql

# disable ssl
sed 's/ssl = true/#ssl = true/' -i ${PG_CONFDIR}/postgresql.conf

# listen on all interfaces
cat >> ${PG_CONFDIR}/postgresql.conf <<EOF
listen_addresses = '*'
EOF

# allow remote connections to postgresql database
cat >> ${PG_CONFDIR}/pg_hba.conf <<EOF
host    all             all             0.0.0.0/0               md5
EOF

# initialize PostgreSQL data directory
if [ ! -d ${PG_DATADIR} ]; then
  echo "Initializing database..."
  PG_PASSWORD=$(pwgen -c -n -1 14)
  echo "${PG_PASSWORD}" > /var/lib/postgresql/pwfile
  sudo -u postgres -H "${PG_BINDIR}/initdb" \
    --pgdata="${PG_DATADIR}" --pwfile=/var/lib/postgresql/pwfile \
    --username=postgres --encoding=unicode --auth=trust >/dev/null
fi

if [ -f /var/lib/postgresql/pwfile ]; then
  PG_PASSWORD=$(cat /var/lib/postgresql/pwfile)
  echo "|------------------------------------------------------------------|"
  echo "| PostgreSQL User: postgres, Password: ${PG_PASSWORD}              |"
  echo "|                                                                  |"
  echo "| To remove the PostgreSQL login credentials from the logs, please |"
  echo "| make a note of password and then delete the file pwfile          |"
  echo "| from the data store.                                             |"
  echo "|------------------------------------------------------------------|"
fi

if [ -n "${DB_USER}" ]; then
  if [ -z "${DB_PASS}" ]; then
    echo ""
    echo "WARNING: "
    echo "  Please specify a password for \"${DB_USER}\". Skipping user creation..."
    echo ""
    DB_USER=
  else
    echo "Creating user \"${DB_USER}\"..."
    echo "CREATE ROLE ${DB_USER} with LOGIN CREATEDB PASSWORD '${DB_PASS}';" |
      sudo -u postgres -H ${PG_BINDIR}/postgres --single \
        -D ${PG_DATADIR} -c config_file=${PG_CONFDIR}/postgresql.conf >/dev/null 2>&1
  fi
fi

if [ -n "${DB_NAME}" ]; then
  echo "Creating database \"${DB_NAME}\"..."
  echo "CREATE DATABASE ${DB_NAME};" | \
    sudo -u postgres -H ${PG_BINDIR}/postgres --single \
      -D ${PG_DATADIR} -c config_file=${PG_CONFDIR}/postgresql.conf >/dev/null 2>&1

  if [ -n "${DB_USER}" ]; then
    echo "Granting access to database \"${DB_NAME}\" for user \"${DB_USER}\"..."
    echo "GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} to ${DB_USER};" |
      sudo -u postgres -H ${PG_BINDIR}/postgres --single \
        -D ${PG_DATADIR} -c config_file=${PG_CONFDIR}/postgresql.conf >/dev/null 2>&1
  fi
fi

echo "Starting PostgreSQL server..."
exec sudo -u postgres -H ${PG_BINDIR}/postgres \
  -D ${PG_DATADIR} -c config_file=${PG_CONFDIR}/postgresql.conf