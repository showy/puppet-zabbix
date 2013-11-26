class puppet-zabbix::server(
	$zabbix_server_pkg 						= 'zabbix-server-pgsql',
	$zabbix_server_pkg_version 				= 'latest',
	$zabbix_server_cfg 						= '/etc/zabbix/zabbix_server.conf',
	$zabbix_db_name 						= 'zabbix',
	$zabbix_db_user 						= 'zabbix',
	$zabbix_db_password 					= 'zabbix',
	$zabbix_server_conf_dbhost 				= 'localhost',
	$zabbix_server_conf_logfile 			= '/var/log/zabbix/zabbix_server.log',
	$zabbix_server_conf_logfilesize 		= '5', # MB
	$zabbix_server_conf_listenport			= '10051',
	$zabbix_server_conf_dbport				= '5432',
) inherits puppet-zabbix::settings {

	# Ensure ordering
	Class["puppet-zabbix::settings"] ->
	Class["puppet-zabbix::server"]

	# this->specific
	if ($support_os_server) {
		case $operatingsystem {
			/(?i:debian)/: {
				case $lsbdistcodename {
					/(?i:wheezy)/: {
						$zabbix_server_cfg_erb = 'zabbix_server_conf_wheezy.erb'
						$zabbix_server_cfg_owner = "zabbix"
						$zabbix_server_cfg_group = "root"
						$zabbix_server_cfg_mode = '0640'
						$have_distro = true
						$zabbix_server_service_name = 'zabbix-server'
						$zabbix_server_service_pattern = 'zabbix_server'
						$zabbix_server_service_hasstatus = false
					}
				}
			}
		}
		if ($have_distro) {

			puppet-zabbix::functions::package_installer { $zabbix_server_pkg: version => $zabbix_server_pkg_version } ->

		    class { 'postgresql::server':
				ip_mask_deny_postgres_user => '0.0.0.0/0',
				#ip_mask_allow_all_users    => '0.0.0.0/0',
				listen_addresses           => '*',
				#ipv4acls                   => ['hostssl all johndoe 192.168.0.0/24 cert'],
				ipv4acls					=> ["host ${zabbix_db_name} ${zabbix_db_user} 127.0.0.1/32 md5"],
				manage_firewall            => false,
				postgres_password          => 'Brut4lP0rt0!',
		    } ->

		    postgresql::server::db { $zabbix_db_name:
				user 		=> $zabbix_db_user,
				password 	=> postgresql_password($zabbix_db_user,$zabbix_db_password),
				require		=> Puppet-zabbix::Functions::Package_installer[$zabbix_server_pkg],
			} ->

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
