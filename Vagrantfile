# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
ifdown eth1
ifup eth1
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.box = "centos/7"
  config.ssh.insert_key = false
  config.vm.provision :shell, inline: $script

  config.vm.define :server do |host|
    _HOSTNAME = "server"
    _PRIVATE_IP_ADDRESS = "192.168.33.10"

    host.vm.hostname = _HOSTNAME
    host.vm.network "private_network", ip: _PRIVATE_IP_ADDRESS
    host.vm.provision :shell, path: "stop-security.sh"
    host.vm.provision :shell, path: "install-fluentd.sh"
    host.vm.provision :shell, path: "install-elasticsearch.sh"
    host.vm.provision :shell, path: "install-kibana.sh"
    host.vm.provision :shell, path: "install-nginx.sh"
  end

end
