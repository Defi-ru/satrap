# satrap
Infrastructure control tool

# Quick start
## I. Prepare satrap server
### Install Ansible on CentOS 7
```
yum install python3-pip -y
pip3 install pip --upgrade
pip3 install ansible netaddr
pip3 --version
```

### Setup server name
```
hostnamectl set-hostname satrap-server.local
```
use FQDN names with domains

### Create & distribute ssh key to servers
```
ssh-keygen
ssh-copy-id satrap-server.local
ssh-copy-id <server01>
ssh-copy-id <server02>
...
```

## II. Install satrap server
```
cd /opt
git clone https://github.com/Defi-ru/satrap.git
cd satrap
```

## Install services via satrap

### Modify inventory
```
vi inventory.yaml
```
Replace server names server01 -> satrap-server.local (or your server name)

### First install DNS & DHCP (optional)
If satrap used as DSN server it must be with static ip
And the server must refer to itself. Itself is indicated in the /etc/reoslf.conf

Install DNS
```
chmod +x satrap
./satrap install dns
```
It will open dns config in vi editor
fill settings (server names & ip adresses)
then save & exit (:wq)

Check DNS is working
```
systemctl status named
```
