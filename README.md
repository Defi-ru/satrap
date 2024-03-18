# satrap
Infrastructure control tool

# Quick start
## Prepare satrap server
### Install Ansible CentOS 7
```
yum install python3-pip -y
pip3 install pip --upgrade
pip3 install ansible
pip3 --version
```

### Download satrap
```
cd /opt
git clone https://github.com/Defi-ru/satrap.git
cd satrap
```

### Modify invntory
```
vi inventory.yaml
```
Replace server names server01 -> myserver.domain.org

### First install DNS & DHCP (ptional)
If satrap used as DSN server it must be with static ip
And the server must refer to itself. Itself is indicated in the /etc/reoslf.conf

Install DNS
```
./satrap install dns
```
fill settings (ip adresses)
