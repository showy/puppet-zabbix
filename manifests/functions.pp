class puppet-zabbix::functions {
	
	define package_installer($version=undef){
		if (!defined(Package[$name])) {
			if (!empty($version)) {
				package { $name:
					ensure => $version,
				}
			} else {
				package { "$name":
					ensure => present,
				}
			}
		}
	}
}