# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

#Vagrant.require_version ">= 1.5.0"
if `vagrant --version` < 'Vagrant 1.5.0'
    abort('Your Vagrant is too old. Please install at least 1.5.0')
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2024"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.box = "centos/7"
  # config.vm.box = "debian/buster64"
  # PHP5 requires Debian Jessie64 see PHP Puppet configuration.
  # config.vm.box = "debian/jessie64"

  config.vm.hostname = "swamp.local"
  config.vm.network :private_network, ip: "192.168.56.24"

  # trying to fix browsersync
  config.vm.network :forwarded_port, guest: 8181, host: 80, auto_correct: true

  if defined? VagrantPlugins::HostsUpdater
  config.hostsupdater.aliases = [
    "db.swamp.local",
    "wp.swamp.local",
    "dev.wp.swamp.local",
    "drupal7.swamp.local",
    "drupal8.swamp.local",
  ]
  end

  # Fix some 'stdin: is not a tty' errors
  # https://github.com/mitchellh/vagrant/issues/1673
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Disable SELinux
  # Issue: for some reason I haven't been able to combine this with $pb_script
  # config.vm.provision :shell, inline: "sudo setenforce 0", run: "always"
  config.vm.provision :shell, inline: "sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config", run: "always"

  # Add path to sudoers
  config.vm.provision :shell, inline: "sudo sed -i 's|/usr/bin|/usr/bin:/usr/local/bin|g' /etc/sudoers", run: "always"

  # Early installation and configurations.
  # Disable selinux, install updates, install helper tools.
  $pb_script = <<-SCRIPT
    sudo yum -y install epel-release yum-utils
    sudo yum -y install yum-plugin-replace
    sudo yum -y update
    /vagrant/scripts/selinux-disable.sh
  SCRIPT

  Vagrant.configure("2") do |config|
    config.vm.provision :shell, inline: $pb_script, run: "always"
  end

  # Reload / Reboot
  config.vm.provision :reload

  # If you have problems TRY: # vagrant plugin install vagrant-vbguest
  # config.vm.synced_folder ".", "/vagrant", owner: "vagrant", group: "vagrant"
  # config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  # Synced folder with custom open permissions.
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox", mount_options: ["dmode=777", "fmode=777"]

  # nfsPath = "."
  # if Dir.exist?("/System/Volumes/Data")
  #     nfsPath = "/System/Volumes/Data" + Dir.pwd
  # end

  # config.vm.synced_folder nfsPath, "/vagrant", type: "nfs", mount_options: ['actimeo=1']

  # config.vm.synced_folder nfsPath, "/vagrant", id: "vagrant", mount_options: ["rw", "tcp", "nolock", "noacl", "async"], type: "nfs", nfs_udp: false

  # config.vm.synced_folder , "/vagrant", type: "nfs", :mount_options => ["dmode=777","fmode=777"]
  # config.vm.synced_folder nfsPath, "/vagrant", owner: "vagrant", group: "vagrant"

  # if (/darwin/ =~ RUBY_PLATFORM) != nil
  #   config.vm.synced_folder nfsPath, "/vagrant", nfs: true, :bsd__nfs_options => ["-maproot=0:0"]
  # else
  #   config.vm.synced_folder nfsPath, "/vagrant", nfs: true, :linux__nfs_options => ["no_root_squash"]
  # end

  # fix some ssh issures
  # ssh settings
  config.ssh.insert_key = false
  config.ssh.keys_only = false
  config.ssh.private_key_path = ["keys/private", "~/.vagrant.d/insecure_private_key"]
  config.vm.provision "file", source: "keys/public", destination: "~/.ssh/authorized_keys"
  config.vm.provision "shell", inline: <<-EOC
    sudo sed -ri 's/#?PubkeyAuthentication\sno/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    sudo systemctl restart sshd.service
  EOC

  # Address a bug in an older version of Puppet
  # See http://stackoverflow.com/questions/10894661/augeas-support-on-my-vagrant-machine
  #config.vm.provision :shell, :inline => "if ! dpkg -s puppet > /dev/null; then sudo apt-get update --quiet --yes && sudo apt-get install puppet --quiet --yes; fi"
  # config.vm.provision :shell, :inline => "dpkg -l | grep puppetlabs >/dev/null ; if [ $? == 1 ];then wget https://apt.puppetlabs.com/puppetlabs-release-squeeze.deb && dpkg -i puppetlabs-release-squeeze.deb && apt-get update && apt-get install -y puppet facter -t puppetlabs;fi"
  # fix apt-get issues in provisioning: https://github.com/zivtech/vagrant-development-vm/issues/11
  #
  #
  # config.vm.provision "shell", :inline => <<-SHELL
  #   sudo yum -y install kernel kernel-devel
  #   sudo yum -y update
  #   sudo yum -y upgrade
  #   sudo yum -y install httpd
  # SHELL
  #
  # Setup Centos via script.
  config.vm.provision :shell, :path => "centos-setup.sh"

  # install PHP Composer
  #  config.vm.provision :shell, :path => "/vagrant/scripts/composer.sh"

  # fixes for vagrant errors found at: https://github.com/hashicorp/vagrant/issues/7508
  #config.vm.provision "fix-no-tty", type: "shell" do |s|
  #  s.privileged = true
  #  s.inline = "sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n \\|\\| true/' /root/.profile"
  #end

  # Shell script setup methods
  # config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.define "centos" do |centos|

      # Backup Databases
      centos.trigger.before :destroy do |trigger|
        trigger.warn = "Dumping database to /vagrant/backups"
        trigger.run_remote = {inline: "/vagrant/scripts/backupdbs.sh"}
        trigger.on_error = :continue
      end

      # Restore Databases
      centos.trigger.after :up do |trigger|
        trigger.warn = "Restoring database from /vagrant/backups"
        trigger.run_remote = {inline: "/vagrant/scripts/restoredbs.sh"}
        trigger.on_error = :continue
      end

    end

end
