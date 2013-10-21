class puppet-zabbix::credentials {
	define instance($dirname="/root/",$username,$password) {
		file { "$dirname/$name":
			ensure => file,
			owner	=> 'root',
			group   => 'root',
			mode	=> 0640,
			content	=> template('zabbix/credentials.erb'),
			replace	=> true,
		}
	}	
}