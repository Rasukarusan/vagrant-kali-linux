Vagrant.configure("2") do |config|
    config.vm.box = "kalilinux/rolling"
    config.vm.box_version = "2019.3.0"
    config.vm.network :private_network, ip: "192.168.56.100"
    config.vm.provider :virtualbox do |v|
        v.gui = false
        v.customize [ "modifyvm", :id, "--memory", 2048]
        v.customize [ "modifyvm", :id, "--nic2","NatNetwork"]
        v.customize [ "modifyvm", :id, "--nictype2","82540EM"]
        v.customize [ "modifyvm", :id, "--nicpromisc2","allow-all"]
    end
    config.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "playbook.yml"
    end
end
