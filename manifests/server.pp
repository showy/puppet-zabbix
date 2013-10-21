class puppet-zabbix::server {
	# This class provider install a zabbix server for debian wheezy
	case $lsbdistcodename {
		/(?i:debian): {
			$zabbix_pkgs = [ 'zabbix-server']
			$zabbix_server_cfg = '/etc/zabbix/zabbix.cfg'
			$have_distro? = True
		}
	}
	if ($have_distro?) {
	}
}