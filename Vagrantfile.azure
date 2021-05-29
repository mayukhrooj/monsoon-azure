IMAGE_NAME = "bento/ubuntu-20.04"
M = 1

Vagrant.configure("2") do |config|
    #config.ssh.insert_key = false
    config.vm.box = 'azure'
    #config.vm.provider "virtualbox" do |v|
    #    v.memory = 3072
    #    v.cpus = 4
    #end

    config.ssh.private_key_path = "~/.ssh/id_rsa"

    config.vm.provider :azure do |azure, override|
        # each of the below values will default to use the env vars named as below if not specified explicitly
        azure.tenant_id = ENV['AZURE_TENANT_ID']
        azure.client_id = ENV['AZURE_CLIENT_ID']
        azure.client_secret = ENV['AZURE_CLIENT_SECRET']
        azure.subscription_id = ENV['AZURE_SUBSCRIPTION_ID']
    end
    
    (1..M).each do |i|
        config.vm.define "Monsoonfintech" do |master|
            #master.vm.box = IMAGE_NAME
            master.vm.network "private_network", ip: "192.168.50.#{10 + 10*(i-1)}"
            master.vm.hostname = "solution"
            master.vm.provision "ansible" do |ansible|
                ansible.playbook = "setupvm.yml"
                ansible.raw_arguments = ["-vv"]
                ansible.extra_vars = {
                    node_ip: "192.168.50.#{10 + 10*(i-1)}",
                    node_name: "solution"
                }
            end
        end
    end
end
