class puppet-zabbix::agent {
	# Include priority classes
	if (!defined(puppet-zabbix::settings)){
		include puppet-zabbix::settings
	}
	if (!defined(puppet-zabbix::base)) {
		include puppet-zabbix::base
	}

	# Ensure ordering
	Class["puppet-zabbix::settings"] ->
	Class["puppet-zabbix::base"] ->
	Class['puppet-zabbix::agent']

	# this->specific
	if ($support_os_agent){
		case $lsbdistcodename {
			/(?i:debian)/: {
				$zabbix_pkgs = [ 'zabbix-agent']
				$zabbix_server_cfg = '/etc/zabbix/zabbix_agent.cfg'
				$have_distro = true
			}
		}
		if ($have_distro) {
			notify {"Zabbix::Agent dot pp":}
		}
	}	
}