class zabbix::credentials(
	$credentials_file="/root/zabbix_credentials_${credentials_instance}.yml",
	$credentials_instance='default'
	) {
	file { "${credentials_file}":
			ensure => file,
			owner	=> 'root',
			group   => 'root',
			content	=> template('zabbix/credentials.erb'),
		}	
}