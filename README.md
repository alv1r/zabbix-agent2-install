
# zabbix-agent2-install
Скрипт для полуавтоматической установки zabbix-agent2 5.0 LTS на OS Ubuntu 20.04.3 LTS (Focal Fossa).

Что делает скрипт?

Скрипт формирует файл настроек, подставляя адрес, полученный из указанного при запуска.

Затем скрипт сохраняет и применяет настройки файервола и перезапускает сервис `zabbix-agent2`

Не забудьте сделать скрипт исполняемым `chmod +x zabbix-agent2-install.sh`

Пример запуска:

    ./zabbix-agent2-install.sh server

где `server` - IP или FQDN Zabbix сервера.

Настройки:

    PidFile=/var/run/zabbix/zabbix_agentd2.pid
    LogFile=/var/log/zabbix/zabbix_agentd2.log
    LogFileSize=5
    Server=
    ServerActive=
    Hostname=
	HostMetadataItem=system.uname
    AllowKey=system.run[*]
    Include=/etc/zabbix/zabbix_agent2.d/*.conf
