class puppet-zabbix::settings(	$zabbix_repo_key_param="http://repo.zabbix.com/zabbix-official-repo.key",
				$zabbix_repo_url_param="http://repo.zabbix.com/zabbix/2.0/debian/",
				$zabbix_repo_sections_param=[ "main", "contrib","non-free"],
				$zabbix_repo_file_param="/etc/apt/sources.list.d/zabbix_repo.list"
) {
	case $operatingsystem {
		/(?i:debian)/: {
			$zabbix_repo_key = $zabbix_repo_key_param
			$zabbix_repo_url = $zabbix_repo_url_param
			$zabbix_repo_file = $zabbix_repo_file_param
			$zabbix_repo_sections = $zabbix_repo_sections_param
			$support_os_server = true
			$support_os_agent = true
			$support = true
		}
	}
}
