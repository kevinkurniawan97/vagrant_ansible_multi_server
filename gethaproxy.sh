cd /etc/haproxy/
sudo apt-get install haproxy
sudo mv haproxy.cfg haproxy.cfg.old
sudo wget https://raw.githubusercontent.com/kevinkurniawan97/vagrant_ansible_multi_server/master/haproxy.cfg

service haproxy restart