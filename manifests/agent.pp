class puppet-zabbix::agent {
	case $lsbdistcodename {
		/(?i:debian)/: {
			$zabbix_pkgs = [ 'zabbix-agent']
			$zabbix_server_cfg = '/etc/zabbix/zabbix_agent.cfg'
			$have_distro? = True
		}
	}
	if ($have_distro?) {
		notify {"Zabbix::Agent dot pp":}
	}
}