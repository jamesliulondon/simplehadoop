Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: "echo Hello"

  config.vm.define "centos7" do |centos7|
    centos7.vm.box = "centos/7"
  end

  config.vm.define "db" do |db|
    db.vm.box = "mysql"
  end
end
