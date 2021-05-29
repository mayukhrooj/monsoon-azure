# Multicontainer proxy passing example

## Introduction
In a VM, created three docker containers(A, B, C) and setup apache inside them. Used official httpd:2.4-alpine image.
Configured apache in container A to map domains to other containers. Only the port 80 of the virtual machine is used for this. The apache running under container a, proxies the requests from

Click on each link to open the page.
- domainb.sytes.net proxies request to container B.
- domainc.sytes.net proxies request to container C.

such that on calling domainb.sytes.net, should show. a page saying "From Container B" and similarly on calling domainc.sytes.net,
should show a page saying "From Container C"

## Requirements

Use the following links to setup the required softwares on a linux box with an internet connection:
- [Vagrant](https://www.vagrantup.com/docs/installation)
- [VirtualBox with vagrant](https://www.taniarascia.com/what-are-vagrant-and-virtualbox-and-how-do-i-use-them/#:~:text=VirtualBox%20is%20basically%20inception%20for,to%20manage%20a%20development%20environment.&text=Using%20VirtualBox%20and%20Vagrant%2C%20you,of%20your%20app%20or%20website.)
- [Docker](https://docs.docker.com/engine/install/)
- [Docker-Compose](https://docs.docker.com/compose/install/)
- [Azure CLI (optional)](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Vagrant with azure (optional)](https://github.com/Azure/vagrant-azure)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## How it works

- Used the httpd image from docker registry to configure the container B and C. In container B and C, an **index.html** file is been created which says "From container B" and "From container C", respectively.
- For container A, I have configured the same image to proxy the requests after looking up the **"Host" request header**. It then uses mod_rewrite to proxy the connections to the desired backend container.
- I have used **docker-compose** utility to create and manage the containers.
- **control-vagrant.sh** is been created to manage vagrant centrally based on the choice of deployment platform (local/azure).
- **Vagrantfile.local** is the vagrant configuration to support one of the desired choice of deployment platform, that is local machine. This is being accomplished by using a virtualbox provider and a chefs, ubuntu20 image from project bento.
- **Vagrantfile** is the vagrant configuration to support one of the desired choice of deployment platfom, that ris azure. Most of the azure related specifications like Resourcegroups, NICs, NSGs, Instance type, Image, disk types, disk sizes, region and vnets have been used in default configurations from the vagrant-azure toolkit. Though this can be overridden at the time of need, we just chose speed over correctness for the sake of this demonstration.
- **setupvm.yml** is a ansible playbook to provision the softwares in the virtual.
- **control-docker.sh** is been configured to control the docker by following setup, status, pid , stop and destroy as per the requirement.

## Running

The solution has been developed to be run in either local or in azure. To run the setup in local you should override an environmnent variable before you trigger the control-vagrant script

All we need to do to setup this is to provision the vm.

### To deploy the vagrant setup locally use

```bash
$ AT=vbox ./control-vagrant.sh start
```

for more options use
```bash
$ ./control-vagrant.sh
```
### Login to the VM

```bash
$ vagrant ssh
```

### To control dockers inside the VM

```bash
/vagrant# ./control-docker.sh status
NAMES                  STATE
vagrant_containerc_1   running
vagrant_containera_1   running
vagrant_containerb_1   running


/vagrant# ./control-docker.sh pid
/vagrant_containerc_1 4108
/vagrant_containera_1 3995
/vagrant_containerb_1 4093


/vagrant# ./control-docker.sh stop
49d11a027a67
c4a71f4de5dd
825375572b68


/vagrant# ./control-docker.sh destroy
Removing vagrant_containerc_1 ... done
Removing vagrant_containera_1 ... done
Removing vagrant_containerb_1 ... done
Removing network vagrant_default


/vagrant# ./control-docker.sh setup
Creating network "vagrant_default" with the default driver
Creating vagrant_containerb_1 ... done
Creating vagrant_containera_1 ... done
Creating vagrant_containerc_1 ... done
```