class puppet-zabbix::server inherits puppet-zabbix::base {
	# Ensure ordering
	Class["puppet-zabbix::settings"] ->
	Class["puppet-zabbix::base"] ->
	Class["puppet-zabbix::server"]

	# this->specific
	if ($support_os_server) {
		case $operatingsystem {
			/(?i:debian): {
				case $lsbdistcodename {
					/(?i:wheezy): {
						$packages = [ 'zabbix-server-mysql']
						$zabbix_server_cfg = '/etc/zabbix/zabbix_server.conf'
						$zabbix_server_cfg_erb = 'zabbix_server.conf.wheezy'
						$zabbix_server_cfg_owner = "root"
						$zabbix_server_cfg_group = "root"
						$zabbix_server_cfg_mode = 0644
						$have_distro = true
						$zabbix_server_service_name = 'zabbix-server'
						$zabbix_server_service_pattern = 'zabbix_server'
						$zabbix_server_service_hasstatus = false
					}
				}
			}
		}
		if ($have_distro) {
			puppet-zabbix::base::package_instaler { $packages: } ->

			file { $zabbix_server_cfg:
				owner	=> $zabbix_server_cfg_owner,
				group 	=> $zabbix_server_cfg_group,
				mode	=> $zabbix_server_cfg_mode,
				ensure 	=> present,
				replace	=> true,
				content	=> template("${module_name}/server/${zabbix_server_cfg_erb}"),
			} ~>

			service { "$zabbix_server_service_name":
			    enable => true,
				ensure => running,
				hasrestart => true,
				hasstatus => $zabbix_server_service_hasstatus,
				pattern 	=> $zabbix_server_service_pattern,
			}
		}
	} else {
		notify { "I don't have support for this operating system/distribution": }
	}
}
