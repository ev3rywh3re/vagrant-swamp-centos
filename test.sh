#/bin/bash


# OF=/var/my-backup-$(date +%Y%m%d).tgz
#  tar -cZf $OF /home/me/

DIR_A=jtest

if [ ! -d "${DIR_A}" ]; then
  mkdir ${DIR_A}
else
  echo "${DIR_A} is here"
fi

if [ -z "$(ls -A ${DIR_A})" ]; then
   echo "Empty"
#   exit 1
else
   echo "Not Empty"
fi

dir_sites_wordpress=/vagrant/sites/wordpress

if [ ! -f "${dir_sites_wordpress}"/wp-config.php ]; then
  echo "File not found!"
else
  echo "File found!"
fi

# cd "${dir_sites_wordpress}"
# echo "IN ${dir_sites_wordpress}"
# pwd
# sudo wp core download
# sudo wp core config --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=127.0.0.1 --dbprefix=wp_
# sudo wp core install --url=wp.swamp.local --title=Site_Title --admin_user=root --admin_password=vagrant --admin_email=wordpress@swamp.local
