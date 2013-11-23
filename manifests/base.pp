class puppet-zabbix::base {
	# Include settings first
	if (!defined(puppet-zabbix::settings)){
		include puppet-zabbix::settings
	}

	#Ensure ordering
	Class["puppet-zabbix::settings"] -> Class["puppet-zabbix::base"]

	# this->specific
	if ($support){

	}	
}