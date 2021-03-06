
# zabbix-agent2-install
Скрипт для полуавтоматической установки [Zabbix agent 2 5.0 LTS](https://www.zabbix.com/documentation/5.0/ru/manual/concepts/agent2) на Ubuntu 18.04.5/20.04 LTS и Debian 9/10

Zabbix agent 2 - новое поколение Zabbix агента, его можно использовать в качестве замены Zabbix агента. Zabbix агент 2 разработан для:

* уменьшения количества TCP соединений
* улучшения многопоточности проверок
* легкого расширения при помощи плагинов. Плагин должен иметь возможности:
* предлагать простые проверки, состоящие только из нескольких строк кода
* предлагать сложные проверки, состоящие из длительно выполняемых скриптов и автономного сбора данных с периодической отправкой данных обратно простой замены Zabbix агента (поскольку он поддерживает все предыдущие функциональности)
* Агент 2 написан на Go (с некоторым переиспользованием C кода из Zabbix агента). Для сборки Zabbix агент 2 требуется подготовленная среда Go версии 1.13+.
* Агент 2 не поддерживает работу в режиме демона.

Пассивные проверки работают аналогично Zabbix агенту. Активные проверки поддерживают интервалы по расписанию/гибкие интервалы, также проверки выполняются параллельно в пределах одного активного сервера.

Параллелизм проверок

Проверки из разных плагинов могут выполняться параллельно. Количество параллельных проверок в пределах одного плагина ограничено настройкой производительности плагина. Каждый плагин может иметь жестко вшитую в код настройку производительности (по умолчанию, 100), значение которой можно уменьшить, указав Plugins.<Имя плагина>.Capacity=N настройку при конфигурировании Plugins параметра.
Поддерживаемые платформы

Агент 2 поддерживается на ллатформах Linux и Windows.

Для установки из пакетов, агент 2 доступен на:

    RHEL/CentOS 8
    SLES 15 SP1+
    Debian 9, 10 (поддерживается скриптом)
    Ubuntu 18.04+ (поддерживается скриптом)


Что делает скрипт?

Скрипт скачивает подключает репозиторий и устанавливает версию агентта, соответствующую версии ОС.

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
