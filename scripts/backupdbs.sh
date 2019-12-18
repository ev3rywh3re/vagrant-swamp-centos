#!/bin/bash

USER="root"
PASSWORD="vagrant"

databases=`mysql -u $USER -p$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "sys" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        sudo mysqldump -u $USER --databases $db > /vagrant/backups/backupdbs.$db.sql
    fi
done
