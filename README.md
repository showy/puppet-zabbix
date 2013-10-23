puppet-zabbix
=============

This module manage the individial components in a zabbix environment. 
Manifests
 - settings.pp
 	General settings.

 - base.pp
 	Maintain zabbix repositories

 - agent.pp
 	Manage zabbix-agent

 - server.pp
 	Manager zabbix-server

 - controller.pp
 	Manage a zabbix host instance in the monitoring system

 - api_connection.pp
 	Save a file with the credentials to access de zabbix api in a designated server

Dependencies

 - settings.pp -> base.pp -> agent.pp
 - settings.pp -> base.pp -> server.pp
 