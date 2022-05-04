# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "zharling/nomad-centos-8-5.box" 
  # config.vm.box = "/Users/zack_harling/code/vagrant/nomad/nomad/centos8-5-nomad1.box"
  config.vm.provider "virtualbox" do |vb|
        vb.memory = "1516"
  end

  # 3-node configuration - Region A
  (1..3).each do |i|
    config.vm.define "nomad-#{i}" do |n|
      n.vm.provision "shell", path: "centos-node-install.sh"
      if i == 1
        # Expose the nomad ports
        n.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true
      end
      n.vm.hostname = "nomad-#{i}"
      n.vm.network "private_network", ip: "192.168.56.#{i+100}"
    end
  end

    # Optional consul clients
    config.vm.define "client" do |client|
      client.vm.hostname = "client-1"
      client.vm.network "private_network", ip: "192.168.56.200"
      client.vm.provision "shell", path: "centos-client-install.sh"
    end

end