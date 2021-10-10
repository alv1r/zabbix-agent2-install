#!/bin/bash
if [ -z "$1" ]
  then
    echo "No argument supplied. Usage: zabbix-agent2-install.sh IP OR FQDN"
fi
echo "Installing Zabbix agent2 v5.0 LTS"
# Get hostname
HOSTNAME=$(hostname -s)
wget --quiet https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb
dpkg -i zabbix-release_5.0-1+focal_all.deb
apt-get update -y
rm zabbix-release_5.0-1+focal_all.deb
apt-get install zabbix-agent2 -y
echo "PidFile=/var/run/zabbix/zabbix_agentd2.pid
LogFile=/var/log/zabbix/zabbix_agentd2.log
LogFileSize=5
Server="$1"
ServerActive="$1"
Hostname="$HOSTNAME"
AllowKey=system.run[*]
Include=/etc/zabbix/zabbix_agent2.d/*.conf" > /etc/zabbix/zabbix_agentd2.conf
# Open ports
iptables -A INPUT -p tcp --dport 10050 -j ACCEPT
# Save rules and reload firewall
iptables-save > /etc/iptables.v4
iptables-restore < /etc/iptables.v4
# Restart service
service zabbix-agent2 restart
echo "Done"
