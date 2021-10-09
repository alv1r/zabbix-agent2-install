#!/bin/sh
echo "Installing Zabbix agent2 v5.4"
# Check Ubuntu version and download proper agent 
VERSION=$(lsb_release -r -s)
# Get hostname
HOSTNAME=$(hostname -s)
# Get server adress
SERVER=$1
wget --quiet http://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix/zabbix-agent2_5.4.0-1+ubuntu"$VERSION"_amd64.deb
dpkg -i zabbix-agent2_5.4.0-1+ubuntu"$VERSION"_amd64.deb
rm zabbix-agent2_5.4.0-1+ubuntu"$VERSION"_amd64.deb
echo "PidFile=/var/run/zabbix/zabbix_agentd2.pid
LogFile=/var/log/zabbix/zabbix_agentd2.log
LogFileSize=5
Server="$SERVER"
ServerActive="$SERVER"
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
