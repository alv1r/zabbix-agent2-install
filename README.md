
# zabbix-agent2-install
Скрипт для полуавтоматической установки zabbix-agent2 на OS Ubuntu Linux с 14 по 20 версии.

Что делает скрипт?

Скрипт скачивает и устанавливает версию программы, соответсвующую установленной редакции Ubuntu.

После этого скрипт формирует файл настроек, подставляя адрес, полученный из указанного при запуска.

Этот же адрес используется для создания правила файервола.

Затем скрипт сохраняет и применяет настройки файервола и перезапускает сервис zabbix-agent2

Пример запуска:

    `zabbix-agent2-install.sh server`

где `server` - IP Zabbix сервера.


`PidFile=/var/run/zabbix/zabbix_agentd2.pid
LogFile=/var/log/zabbix/zabbix_agentd2.log
LogFileSize=5
Server=
ServerActive=
Hostname=
AllowKey=system.run[*]
Include=/etc/zabbix/zabbix_agent2.d/*.conf`=`
