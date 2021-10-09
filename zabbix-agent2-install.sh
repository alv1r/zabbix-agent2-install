#!/bin/sh
echo "Installing Zabbix agent2"
# Check Ubuntu version and download proper agent 14-20
VERSION=$(lsb_release -r -s)
# Get hostname
HOSTNAME=$(hostname -s)
wget --quiet http://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix/zabbix-agent2_5.4.0-1+ubuntu"$VERSION"_amd64.deb
dpkg -i zabbix-agent2_5.4.0-1+ubuntu"$VERSION"_amd64.deb
rm zabbix-agent2_5.4.0-1+ubuntu"$VERSION"_amd64.deb
echo "PidFile=/var/run/zabbix/zabbix_agentd2.pid
LogFile=/var/log/zabbix/zabbix_agentd2.log
LogFileSize=5
Server=%server_name%
ServerActive=%server_name%
Hostname="$HOSTNAME"
AllowKey=system.run[*]
Include=/etc/zabbix/zabbix_agent2.d/*.conf" > /etc/zabbix/zabbix_agentd2.conf
# Open ports
iptables -I INPUT -m state --state NEW -s %server_name%/32 -p tcp -m tcp --dport 10050 -j ACCEPT
# Reload firewall
iptables-save > /etc/iptables.v4
iptables-restore < /etc/iptables.v4
# Restart service
service zabbix-agent2 restart
echo "Done"
