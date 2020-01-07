#!/bin/bash

USER="root"
PASSWORD="vagrant"
DIR_BAKS=/vagrant/backups/

if [ -z "$(ls -A ${DIR_BAKS})" ]; then
   echo "No backup database files!"
   exit 0
fi

cd ${DIR_BAKS}

databases=`ls -1 *.sql`

for db in $databases; do
        echo "Importing $db ..."
        sudo mysql -u $USER < $db
done
