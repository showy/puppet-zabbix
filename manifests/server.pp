class puppet-zabbix::server {
	# Include priority classes
	if (!defined(puppet-zabbix::settings)) {
		include puppet-zabbix::settings
	}
	if (!defined(puppet-zabbix::base)) {
		include puppet-zabbix::base
	}

	# Ensure ordering
	Class["puppet-zabbix::settings"] ->
	Class["puppet-zabbix::base"] ->
	Class["puppet-zabbix::server"]

	# this->specific
	if ($support_os_server) {
		# This class provider install a zabbix server for debian wheezy
		case $lsbdistcodename {
			/(?i:debian): {
				$zabbix_pkgs = [ 'zabbix-server']
				$zabbix_server_cfg = '/etc/zabbix/zabbix.cfg'
				$have_distro = true
			}
		}
		if ($have_distro) {
		}
	}
}