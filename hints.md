Readme File

Ports
Grafana 3000
InfluxDB 8086

Firewalld Hints
# Grafana
firewall-cmd --permanent --zone=public --add-port=3000/tcp
# InfluxDB
firewall-cmd --permanent --zone=public --add-port=8086/tcp
firewall-cmd --reload

# DNS (Bind/Named)
firewall-cmd --permanent --zone=public --add-port=53/tcp
firewall-cmd --permanent --zone=public --add-port=53/udp
firewall-cmd --reload
