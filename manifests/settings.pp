class puppet-zabbix::settings {

	case $operatingsystem {
		/(?i:debian)/: {
			$support_os_server = true
			$support_os_agent = true
			$support = true
		}
	}
}
