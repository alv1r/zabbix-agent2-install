#!/bin/bash
# Check for command line arguments
if [ -z "$1" ]
  then
    echo "No argument supplied. Usage: zabbix-agent2-install.sh IP OR FQDN"
fi
# Check for a root rights
if ! [ $(id -u) = 0 ]; then
   echo "I am not root!"
   exit 1
fi
# Installing dependency dependencies
 apt-get install wget iptables-persistent -y
echo "Installing Zabbix agent2 v5.0 LTS"
# Get hostname
HOSTNAME=$(hostname -s)
# Get OS codename
OSVERSION=$(lsb_release -sc)
if [[ "$OSVERSION" =~ ^(bionic|focal)$ ]]; then
# Installing Zabbix Agent 2 on Ubuntu 18/20
  wget --quiet https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+"$OSVERSION"_all.deb
  dpkg -i zabbix-release_5.0-1+"$OSVERSION"_all.deb
  apt-get update -y
  rm zabbix-release_5.0-1+"$OSVERSION"_all.deb
  apt-get install zabbix-agent2 -y
# Stoping service
  service zabbix-agent2 stop
# Remove old config file
  em -f /etc/zabbix/zabbix_agentd2.conf
# Create new config file
  echo "PidFile=/var/run/zabbix/zabbix_agentd2.pid
  LogFile=/var/log/zabbix/zabbix_agentd2.log
  LogFileSize=5
  Server="$1"
  ServerActive="$1"
  Hostname="$HOSTNAME"
  HostMetadataItem=system.uname
  AllowKey=system.run[*]
  Include=/etc/zabbix/zabbix_agent2.d/*.conf" > /etc/zabbix/zabbix_agentd2.conf
# Open ports
  iptables -A INPUT -p tcp --dport 10050 -j ACCEPT
# Save rules and reload firewall
  iptables-save > /etc/iptables.v4
  iptables-restore < /etc/iptables.v4
# Start service
  service zabbix-agent2 start
elif [[ "$OSVERSION" =~ ^(stretch|buster)$ ]]; then
# Installing Zabbix Agent 2 on Debian 9/10
  wget --quiet https://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-1+"$OSVERSION"_all.deb
  dpkg -i zabbix-release_5.0-1+"$OSVERSION"_all.deb
  apt-get update -y
  rm zabbix-release_5.0-1+"$OSVERSION"_all.deb
  apt-get install zabbix-agent2 -y
  echo "PidFile=/var/run/zabbix/zabbix_agentd2.pid
  LogFile=/var/log/zabbix/zabbix_agentd2.log
  LogFileSize=5
  Server="$1"
  ServerActive="$1"
  Hostname="$HOSTNAME"
  HostMetadataItem=system.uname
  AllowKey=system.run[*]
  Include=/etc/zabbix/zabbix_agent2.d/*.conf" > /etc/zabbix/zabbix_agentd2.conf
# Open ports
  iptables -A INPUT -p tcp --dport 10050 -j ACCEPT
# Save rules and reload firewall
  iptables-save > /etc/iptables.v4
  iptables-restore < /etc/iptables.v4
# Restart service
  service zabbix-agent2 restart
else
  echo "$OSVERSION is not supported"

fi

