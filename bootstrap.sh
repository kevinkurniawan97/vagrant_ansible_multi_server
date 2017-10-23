#!/usr/bin/env bash

# install ansible (http://docs.ansible.com/intro_installation.html)
apt-get -y install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get -y install ansible

# copy examples into /home/vagrant (from inside the mgmt node)
cp -a /vagrant/examples/* /home/vagrant
chown -R vagrant:vagrant /home/vagrant

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL
# vagrant environment nodes
10.0.15.15  mgmt
10.0.15.16  loadbalancer
10.0.15.21  web1
10.0.15.22  web2
10.0.15.23  web3
10.0.15.24  web4
10.0.15.25  web5
10.0.15.26  web6
10.0.15.27  web7
10.0.15.28  web8
10.0.15.29  web9
EOL

#install Apache
sudo apt-get -y install sshpass
sudo apt-get -y install apache2-utils

cat >> /etc/ansible/hosts <<EOL

[webserver]
web1 ansible_ssh_pass=vagrant ansible_ssh_user=vagrant
web2 ansible_ssh_pass=vagrant ansible_ssh_user=vagrant

[lb]
loadbalancer ansible_ssh_pass=vagrant ansible_ssh_user=vagrant
EOL

cat >> /etc/ansible/ansible.cfg <<EOL
[defaults]
host_key_checking = False
EOL

ssh-keyscan -H loadbalancer >> /home/vagrant/.ssh/known_hosts
ssh-keyscan -H web1 >> /home/vagrant/.ssh/known_hosts
ssh-keyscan -H web2 >> /home/vagrant/.ssh/known_hosts

cd /vagrant/
sshpass -p vagrant ansible-playbook apache.yml --ask-pass
sshpass -p vagrant ansible-playbook haproxy.yml --ask-pass

sudo service haproxy restart