#!/bin/bash

USER="root"
PASSWORD="vagrant"

cd /vagrant/backups/

databases=`ls -1 *.sql`

for db in $databases; do
        echo "Importing $db ..."
        sudo mysql -u $USER < $db
done
