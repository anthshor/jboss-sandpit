MY_VAR = ENV['MY_VAR']
Vagrant.configure("2") do |config|
  config.vm.box = "anthshor/centos72"
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
  end
  config.vm.synced_folder "~/proxy", "/proxy"
  config.vm.network "private_network", ip: "192.168.33.31" 
  config.vm.provision "shell", path: "provision.sh", args: MY_VAR  
end
