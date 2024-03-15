#!/bin/bash
# script name: ip-worwarding.sh

EXTERNAL_NIC=eth0
INTERNAL_NIC=eth1

CLEAR_COLOR="\033[0m"
RED_COLOR="\033[31m"

# Centos 7
function install_centos {
	echo "net.ipv4.ip_forward = 1" > /etc/sysctl.conf
	sysctl -p
	firewall-cmd --permanent --zone=public --add-masquerade
	firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -o $EXTERNAL_NIC -j MASQUERADE
	firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i $INTERNAL_NIC -o $EXTERNAL_NIC -j ACCEPT
	firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i $EXTERNAL_NIC -o $INTERNAL_NIC -m state --state RELATED,ESTABLISHED -j ACCEPT
	firewall-cmd --runtime-to-permanent
	firewall-cmd --reload
}
firewall-cmd --zone=public --add-forward

command() {
  case "$1" in
    install )
      install_centos
      ;;
    *)
	  echo ""
	  echo -e "$RED_COLOR Check configs: $CLEAR_COLOR"
	  echo ""
      echo "External NIC: $EXTERNAL_NIC"
      echo "Internal NIC: $INTERNAL_NIC"
      echo ""
      echo $"Usage: $0 { install }"
      echo ""  
	  exit 1
   esac
}

command "$1"

exit 0
