class puppet-zabbix::agent(
	$zabbix_servers,
	$zabbix_pkg_version = 'present',
	$zabbix_config_logfile = '',
	$zabbix_config_logfilesize=0,
	$zabbix_config_enableremotecommands=0,
) inherits puppet-zabbix::settings {

	# Class relationship
	Class["puppet-zabbix::settings"]->
	Class["puppet-zabbix::agent"]	


	# this->specific
	if ( $support_os_agent ) {
		case $lsbdistcodename {
			/(?i:wheezy)/: {
				$packages = [ 'zabbix-agent' ]
				$zabbix_agentd_cfg = '/etc/zabbix/zabbix_agentd.conf'
				$zabbix_agentd_cfg_erb = 'zabbix_agentd_conf_wheezy.erb'
				$zabbix_agentd_cfg_owner = "root"
				$zabbix_agentd_cfg_group = 'root'
				$zabbix_agentd_cfg_mode = '0644'
				$have_distro = true
				$zabbix_agentd_service_pattern = 'zabbix_agentd'
				$zabbix_agentd_service_hasstatus = false
				$zabbix_agentd_service_name = 'zabbix-agent'
			}
			/(?i:squeeze)/: {
				$packages = [ 'zabbix-agent' ]
				$zabbix_agentd_cfg = '/etc/zabbix/zabbix_agentd.conf'
				$zabbix_agentd_cfg_erb = 'zabbix_agentd_conf_squeeze.erb'
				$zabbix_agentd_cfg_owner = "root"
				$zabbix_agentd_cfg_group = 'root'
				$zabbix_agentd_cfg_mode = '0644'
				$have_distro = true
				$zabbix_agentd_service_pattern = 'zabbix_agentd'
				$zabbix_agentd_service_hasstatus = false
				$zabbix_agentd_service_name = 'zabbix-agent'
			}

		}
		if ($have_distro) {
			puppet-zabbix::functions::package_installer { $packages: version => $zabbix_pkg_version } ->

			file {$zabbix_agentd_cfg:
				owner	=> $zabbix_agentd_cfg_owner,
				group 	=> $zabbix_agentd_cfg_group,
				mode	=> $zabbix_agentd_cfg_mode,
				ensure	=> present,
				replace	=> true,
				content	=> template("${module_name}/agent/${zabbix_agentd_cfg_erb}"),
				require	=> Package[$packages],
			} ~>

			service { $zabbix_agentd_service_name:
			    enable => true,
				ensure => running,
				hasrestart => true,
				hasstatus	=> $zabbix_agentd_service_hasstatus,
				pattern		=> $zabbix_agentd_service_pattern,
			}
		}
	} else {
		notify { "I don't have support for this operating system/distribution": }
	}	
}
