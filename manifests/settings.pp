class puppet-zabbix::settings {
	case $operatingsystem {
		/(?i:debian)/: {
			$module_name = "puppet-zabbix"
			$zabbix_repo_key = "http://repo.zabbix.com/zabbix-official-repo.key"
			$zabbix_repo_url = "http://repo.zabbix.com/zabbix/2.0/debian/"
			$zabbix_repo_sections = [ "main", "contrib","non-free"]
			$support_os_server = true
			$support_os_agent = true
			$support = true
		}
	}
}