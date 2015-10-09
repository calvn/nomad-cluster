# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  #== Global config
  config.vm.provider "parallels" do |p, o|
    p.memory = "512"
  end

  config.vm.provider "virtualbox" do |vb|
        vb.memory = "512"
  end

  ["vmware_fusion", "vmware_workstation"].each do |p|
    config.vm.provider p do |v|
      v.vmx["memsize"] = "512"
    end
  end

  # Hostmanager
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.include_offline = true

  # Provisioners
  config.vm.provision "shell", path: "scripts/bootstrap.sh", privileged: false
  config.vm.provision "docker" # Just install docker

  #== Nomad servers
  1.upto(3) do |i|
    config.vm.define "nomad-server#{i}" do |server|
      server.vm.box = "puphpet/ubuntu1404-x64"
      server.vm.hostname = "nomad-server#{i}"
      server.vm.network "private_network", ip: "192.168.111.#{i + 1}"

      server.vm.provision "shell", path: "scripts/server.sh", args: "192.168.111.#{i + 1}", privileged: false
      server.vm.provision "shell", path: "scripts/join.sh", privileged: false

      server.hostmanager.manage_host = true
      server.hostmanager.aliases = %W(nomad-server#{i}.node.dc1.consul)
    end
  end

  #== Nomad client
  config.vm.define "nomad-client" do |client|
    client.vm.box = "puphpet/ubuntu1404-x64"
    client.vm.hostname = "nomad-client"

    client.vm.network "private_network", ip: "192.168.111.5"

    client.vm.provision "shell", path: "scripts/client.sh", privileged: false

    client.hostmanager.manage_host = true
    client.hostmanager.aliases = %W(nomad-client.node.dc1.consul)
  end
end
