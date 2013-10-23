class puppet-zabbix::api_connection {
	define instance($dirname="/root/",$username,$password) {
		file { "$dirname/$name":
			ensure => file,
			owner	=> 'root',
			group   => 'root',
			mode	=> 0640,
			content	=> template("${module_name}/api_connection/credentials.erb"),
			replace	=> true,
		}
	}	
}