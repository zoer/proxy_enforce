# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "chef/debian-7.7"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "256"
  end

  config.vm.provision "shell", inline: <<-SHELL
    source /root/.profile
    /vagrant/dev/provision/update
    /vagrant/dev/provision/rbenv
    /vagrant/dev/provision/ruby
  SHELL
end
