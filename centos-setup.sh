#!/usr/bin/env bash

echo '-!!!- Centos Setup Script -!!!-'

# Install httpd and dependencies
sudo yum -y install wget
sudo yum -y install httpd
sudo yum -y install git
sudo yum -y install unzip

# Setup REMI repository. Install php

sudo yum -y install epel-release
sudo wget -q http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo wget -q https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php72

# sudo scl enable php72 bash
sudo yum -y update
# Install Apache & PHP dependencies
# --------------------

# Install MariaDB
# ---------------
# Install MaridDB repos
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
sudo yum -y install mariadb-server mariadb
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service
sudo systemctl stop mariadb.service
sudo mysqladmin shutdown
sudo mysqld_safe --skip-grant-tables &
# sudo mysql -u root -e "REPLACE INTO mysql.user (Host, User, Password) VALUES ('%', 'root', password('vagrant')); GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;"
# sudo mysql -u root -e "REPLACE INTO mysql.user (Host, User, Password) VALUES ('localhost', 'root', password('vagrant')); GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
# sudo mysql -u root -e "USE mysql; update user SET PASSWORD=PASSWORD('vagrant') WHERE USER='root'; flush privileges;"
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'vagrant';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

sudo mysqladmin shutdown

# sudo mysql -u root -e "INSERT INTO mysql.user (Host, User, Password) VALUES ('%', 'root', password('vagrant'));"
# sudo mysql -u root -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;"

sudo systemctl start mariadb.service

# sudo mysql -u root -e "use mysql; update  user SET PASSWORD=PASSWORD('vagrant') WHERE USER='root'; flush privileges;"
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'vagrant';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

# sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS wp"
# sudo mysql -u root -e "GRANT ALL PRIVILEGES ON wp.* TO 'wp'@'localhost' IDENTIFIED BY 'password'"
# sudo mysql -u root -e "FLUSH PRIVILEGES"
# sudo mysql -u root -e "INSERT INTO mysql.user (Host, User, Password) VALUES ('%', 'root', password('vagrant'));"
# sudo mysql -u root -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;"

sudo systemctl stop mariadb.service
sudo systemctl start mariadb.service

# sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS wp"
# sudo mysql -u root -e "GRANT ALL PRIVILEGES ON wp.* TO 'wp'@'localhost' IDENTIFIED BY 'password'"
# sudo mysql -u root -e "FLUSH PRIVILEGES"

# install PHP
sudo yum -y install --enablerepo=remi-php72 php php-common php-cli php-zip mod_php php-xml php-opcache php-pdo php-mysql php-mbstring php-gd

# enable apache vhosts
sudo cp /vagrant/files/etc/httpd/conf.d/default-sites.conf /etc/httpd/conf.d
sudo cp /vagrant/files/etc/httpd/httpd.conf /etc/httpd/conf/httpd.conf

# strange php session errors...
sudo chown -R vagrant:vagrant /var/lib/php/session

# Restart apache
# ---------------
sudo systemctl enable httpd.service
sudo systemctl start httpd.service
sudo systemctl restart httpd.service

# Double check sckript permissions
sudo chmod ug+x /vagrant/scripts/*

# Install node
sudo yum -y install nodejs

# Install yarn
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
sudo yum -y install yarn

# Install and configure latest phpMyAdmin
sudo rm -Rf /vagrant/sites/db
sudo mkdir /vagrant/sites/db
sudo chmod -Rf ug+rw /vagrant/sites/db
sudo chown -Rf vagrant.vagrant /vagrant/sites/db
sudo cd /vagrant/sites/db/
# rm -rf .[!.] .??*
# install composer
sudo /vagrant/scripts/composer.sh
# install phpmyadming
sudo composer create-project phpmyadmin/phpmyadmin /vagrant/sites/db

# Install WP-CLI and WordPress
cd ~/
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# sudo mysql -u root -e "use mysql; update user SET PASSWORD=PASSWORD('vagrant') WHERE USER='root'; flush privileges;"
# sudo mysqladmin shutdown
# sudo systemctl restart mariadb.service
# sudo mysql -u root --password="vagrant" -e "use mysql; update user SET PASSWORD=PASSWORD('vagrant') WHERE USER='root'; flush privileges;"
sudo mysql -u root -p'vagrant' -e "CREATE DATABASE IF NOT EXISTS wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%' IDENTIFIED BY 'wordpress'; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'wordpress'; flush privileges;"

sudo cd /vagrant/sites/wp

sudo wp core download
sudo wp core config --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=127.0.0.1 --dbprefix=wp_
sudo wp core install --url=wp.swamp.local --title=Site_Title --admin_user=root --admin_password=vagrant --admin_email=wordpress@swamp.local

# Instal Drupal Varbase - Development ladden Drupal Distrobution.
# cd /vagrant/sites/drupal-8
# Use PHP Composer to install Drupal Varbase
# sudo composer create-project Vardot/varbase-project:^8.7.3 /vagrant/sites/drupal-8 --no-dev --no-interaction
