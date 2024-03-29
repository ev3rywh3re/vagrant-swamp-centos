# Vagrant Swamp - CentOS

This is a total mess of a VM for local web development. The intention is to load some tools like phpMyAdmin and a few web apps like WordPress and Drupal. It was originally built for my old laptop that needed something with low requirements, and now it's become my light web development VM sketchbook. I use it for web development and experimentation. This version uses CentOS as the Linux distribution.

This project has a simple set of goals:

* Setup a WordPress site at (http://wp.swamp.local)
* Setup a WordPress site at (http://dev.wp.swamp.local) - intended for WordPress multisite.
* Setup a phpMyAdmin site at (http://db.swamp.local)
* Allow access to WordPress files at [this-directory]/sites/www/
* Allow access to phpMyAdmin files at [this-directory]/sites/db/

# Installation

Required software

* Virtualbox
* Vagrant
* Vagrant - hostsupdater

**Virtualbox**

Virtualbox is a virtual computer system allowing you to have the Linux Operating System running inside your current computer operating system. VirtualBox is usable on MacOS, Windows, and Linux. You can download and install this software by visiting (https://www.virtualbox.org)

**Vagrant**

Vagrant is a virtual machine management application. Vagrant allows the configuration and setup of virtual computers. The Vagrant application uses VirtualBox to launch and run the virtual computers running on your local computer. You can download and install Vagrant by visiting (https://www.vagrantup.com/)

**Vagrant - hostsupdater**

Vagrant - hostsupdater is a plugin for the Vagrant application that allows it to modify the networking settings of your main operating system. This will allow you to use customized hostnames and domain names.

## Instalation Procedure

All installation procedures assume you have administrative access to your comparator to install software. Some of these procedures utilize installation applications that are common to most computer users, but some steps may require the use of a terminal application to run some commands. On MacOS these commands are run using Terminal, and on many versions of Windows the commands will use the CMD application.

### Primary Applications & Utilities

These are the basic applications and utilities that need to be installed.

1. Install VirtualBox by visiting (https://www.virtualbox.org), downloading the latest version, and running the downloaded installation application.
2. Install Vagrant by visiting (https://www.vagrantup.com/), downloading the latest version, and running the downloaded installation application.
3. Install Vagrant - hostsupdater by using a command line utility (on MacOS use Terminal and on Windows use CMD). The command to use is `# vagrant plugin install vagrant-hostsupdater`
4. It may be necessary to  install the Vagrant guest additions for your system. `# vagrant plugin install vagrant-vbguest` This may also require installation of an older version of the vbguest plugin if you get errors like (https://www.devopsroles.com/vagrant-no-virtualbox-guest-additions-installation-found-fixed/):
`# vagrant plugin uninstall vagrant-vbguest`
`# vagrant plugin install vagrant-vbguest --plugin-version 0.21`
5. Recent versions have Vagrant trigger options build in, but for older versions you may need to install this plugin for triggers. To preserve the databases between destroy & up you will need Vagrant Trigger options. `# vagrant plugin install vagrant-triggers`
6. I use another plugin to restart the vm after disabling SELinux.
`# vagrant plugin install vagrant-reload`


### Simple WordPress Vagrant Installation

1. Download the archive for this repository.
2. Uncompress this archive on the computer where you've installed and configured VirtualBox, Vagrant, and Vagrant - HostsUpdater.
3. Using a terminal application or other command line utility, attempt to run the `# vagrand up` command.
4. Once complete you should be able to interact with your MySQL databases by visiting http://db.wp.loc, and you can start your WordPress installation by visiting http://www.wp.loc.

## Simple WordPress Vagrant Usage

The Simple WordPress Vagrant environment is fairly easy to manage and is meant to offer a cheap relatively simple way to learn WordPress web development. The goal is to create a system that will offer some familiarity by using the operating system you are familiar with. The following commands will use the command line terminal available on your operating system.

**To Perform Setup and Activate the Simple WordPress Vagrant**

1. Use the command line utility on your computer and visit the uncompressed directory downloaded from (https://github.com/ev3rywh3re/vagrant-wp-simple)
2. use the command `# vagrant up` to perform the install and activation.

**To Test and Use the Simple WordPress Vagrant**

If everything installed fine and is working great, you should have the following URLs running on your local computer.

* (http://db..swamp.local) - The phpMyAdmin utility. This utility is installed so you can interact with the database portion of the WordPress installation. Information about phpMyAdmin can be found at (https://www.phpmyadmin.net).
* (http://wp.swamp.local) - Your local WordPress installed. This installation is a fresh installation, so you will still need to supply the basic information when you first setup your Simple WordPress Vagrant.
* (http://dev.wp.swamp.local) - Another local WordPress installed. This installation is a fresh installation, so you will still need to supply the basic information when you first setup your Simple WordPress Vagrant. This additional domain is added intentionally so that a WordPress multisite configuration would be used in addition to a normal WordPress site.

The **WordPress** portion of your Simple WordPress Vagrant has been prepared with two basic databases and a database user for you to use in the WordPress installations on (http://wp.swamp.local) and (http://dev.wp.swamp.local). The MySQL database, user, and password are as follows:

* Database name: wordpress
* Database user: wordpress
* Database password: wordpress

* Database name: wordpress_multi
* Database user: wordpress
* Database password: wordpress

The **files for your Simple WordPress Vagrant site** will be found in [this-directory]/sites/www/ and [this-directory]/sites/dev/. This means that you will be able to directly edit files and install themes into [this-directory]/sites/www/wp-content/themes/ as well as [this-directory]/sites/dev/wp-content/themes/ and plugins into [this-directory]/sites/www/wp-content/plugins/ as well as [this-directory]/sites/dev/wp-content/plugins/.

**To Shutdown the Simple WordPress Vagrant**

Use your computers command line utility and submit the `# vagrant halt` command. This is a non-destructive option that will shutdown the virtual system and you will be able to restart the system by issuing the `# vagrant up` command.

**To Reset and Remove the Simple WordPress Vagrant**

This option is also still partially non-destructive, but this will remove the virtual system and destroy the database used by your (http://www.wp.loc) site. To perform this option, use your operating system command line utility to run the `# vagrant destroy` command. **This option will not modify files in the [this-directory]/sites/www or [this-directory]/sites/db directories.**

**Other Ways to Interact With Your New System**

This simple Vagrant setup uses the standard Vagrant accounts. **Be aware that this type of system is intended for development purposes and this system is not secure. Please review all security before making systems like this accessible to the internet.**

You will be able to access this systems by using SSH on your local system. Using SSH will allow you to login and access the virtual server from the local machine where you've installed VirtualBox and Vagrant. You learn more elsewhere about using SSH to manage Linux systems. Here are the basic user accounts and root or administrative user account.

* General user account: Username: vagrant Password: vagrant
* Root administrative user: Username: root Password: vagrant

##WordPress Multisite Notes##

For now I am putting my personal notes for separating the WordPress core installation and activating multisite. Although I intend to keep this project vary basic, the goal is keep things simple so this vagrant configuration can be used to learn more about complex web applicaions like WordPress.

1. Put WordPress into a subfolder in the website root. In this case I'm using /vagrant/sites/dev/wp/
2. Run the automated WordPress install procedure. Set up admin account, log in, set permalink settings.
3. Copy /wp/index.php and /wp/wp-config.php up one level to website root.
4. Modify /wp/index.php to properly reference the WordPress files in /wp/. It may look like `require( dirname( __FILE__ ) . '/wp/wp-blog-header.php' );`
5. Test the site at the main domain.
6. Make sure the database options are set properly. The Site URL (home) will be the main URL (dev.wp.loc in this case). The WordPress URL (siteurl) will be the address for the full WordPress install (dev.wp.loc/wp in this case)
7. Test the site at dev.wp.loc and log in to test the account. Update the permalink settings and update the .htaccess file if necessary.
9. Next I will use the `define('WP_CONTENT_DIR', '');` and `define('WP_CONTENT_URL', '');` to reference the wp-content folder in the website root. This actually makes the WordPress site work as a wordpress site normally works with the /wp-content folder in the site root.
10. Now I follow the wp-config.php and other procedures for enabling multisite. This is a multi-step process which requires manual editing of the wp-config.php and .htaccess files.

The goal is to have a clean /sites/dev/ folder with WordPress core residing in /sites/dev/wp/ while themes, plugins, and uploads reside in /sites/dev/wp-content/. This configuration makes it easy to maintain WordPress and other additional plugins, themes, and user uploads separately.
