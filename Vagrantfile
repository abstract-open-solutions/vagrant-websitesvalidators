# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "deb/jessie"

  # Apache port
  config.vm.network "forwarded_port", guest: 80, host: 8880
  # validator.nu port
  config.vm.network "forwarded_port", guest: 8888, host: 8888
  # Tomcat7 port
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Share an additional folder to the guest VM.
  # config.vm.synced_folder "./vagrant_data", "/vagrant_data"

  config.vm.provision "file", source: "config", destination: "~/config"
  config.vm.provision "shell", path: "install-validators.sh"

end
