Vagrant.require_version ">= 1.7.0"

Vagrant.configure("2") do |config|

  # config.vm.box = "bento/ubuntu-16.04"
  config.vm.box = "bento/centos-7.3"
  config.vm.define "ironic-dev" do |n|
    n.vm.hostname = "ironic-dev"
    # n.vm.network :private_network, ip: "192.168.50.5", virtualbox__intnet: true
    n.vm.network :private_network, ip: "192.168.20.6", auto_config: true, :mac => "5CA1AB1E0001"
    n.vm.network :private_network, ip: "192.168.30.6", auto_config: true, :mac => "5CA1AB1E0002"

    n.vm.provider :virtualbox do |vb, override|
      vb.name = "#{n.vm.hostname}"
      vb.memory = 4096
      vb.cpus = 2
    end
  end
  # Install of dependency packages using script
  config.vm.provision :shell, path: "./scripts/initial.sh"
end
