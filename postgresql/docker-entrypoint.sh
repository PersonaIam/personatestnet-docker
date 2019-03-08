#!/bin/bash

pg_shutdown() {
gosu postgres pg_ctl -D $PGDATA stop
echo $?
}

trap pg_shutdown SIGINT SIGTERM

if [ -z "$(ls -A "$PGDATA")" ]; then
   chown -R postgres "$PGDATA"
   gosu postgres initdb
   gosu postgres postgres -D $PGDATA -c config_file=$PG_CONFIG &
   pg_pid=$!
fi
   echo "Starting Postgresql"
   gosu postgres postgres -D $PGDATA -c config_file=$PG_CONFIG &
   pg_pid=$!
   
if [[ -z $DB_USER || -z $DB_NAME ]]; then
    echo "DB_USER and DB_NAME empty"
else
   until pg_isready
   do
     echo "Waiting for postgres to start"
     sleep 5;
   done

   echo "User and Database"
   DB_USER_EXISTS=$(sudo -i -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname = '${DB_USER}'" | grep -c "1")
   DB_NAME_EXISTS=$(sudo -i -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = '${DB_NAME}'" | grep -c "1")

   if [[ $DB_USER_EXISTS == 1 ]]; then
       echo "The database user already exists."
   else
       echo "Create Database User"
       sudo -i -u postgres psql -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}' CREATEDB;"
   fi

   if [[ $DB_NAME_EXISTS == 1 ]]; then
       echo "The database already exists."
   else
       echo "Create Database"
       sudo -i -u postgres psql -c "CREATE DATABASE ${DB_NAME} WITH OWNER ${DB_USER};"
   fi
fi

echo "$pg_pid"
wait "$pg_pid"

echo "exited $0"
