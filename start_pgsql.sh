#!/bin/bash

if [[ ! -f /opt/postgresql/initialized ]]; then
    mkdir -p /opt/postgresql
    cp -a /var/lib/postgresql/* /opt/postgresql/
    chown -R postgres:postgres /opt/postgresql
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "CREATE USER root WITH SUPERUSER PASSWORD '$1';"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "update pg_database set datallowconn = TRUE where datname = 'template0';"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "\c template0"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "update pg_database set datistemplate = FALSE where datname = 'template1';"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "drop database template1;"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "create database template1 with template = template0 encoding = 'UTF8';"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "update pg_database set datistemplate = TRUE where datname = 'template1';"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "\c template1"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "update pg_database set datallowconn = FALSE where datname = 'template0';"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "CREATE DATABASE db ENCODING 'UTF8' TEMPLATE template1;"
    touch /opt/postgresql/initialized
fi
su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres           -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf  -c listen_addresses=*"
