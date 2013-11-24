class puppet-zabbix::base($zabbix_agent_version='latest') inherits puppet-zabbix::settings {
	# Ordering
	Class["puppet-zabbix::settings"] -> Class["puppet-zabbix::base"]

	define package_installer(){
		if (!defined(Package[$name])) {
			if ($name == 'zabbix-agent-noop') {
				package { $name:
					ensure => $zabbix_agent_version,
				}
			} else {
				package { "$name":
					ensure => present,
				}
			}
		}
	}
	# this->specific
	if ($support){
		case $operatingsystem {
			/(?i:debian)/: {
				case $lsbdistcodename {
					/(?i:wheezy|squeeze)/: {
						$packages = [ "curl"] # This package list is required by resources in this file
						$zabbix_repo_file_erb = "debian_repo_file.erb"
					}
				}
			}
		}

		package_installer {$packages:} 

		file { $zabbix_repo_file:
			owner	=> "root",
			group 	=> "root",
			mode	=> 0644,
			content	=> template("${module_name}/base/${zabbix_repo_file_erb}"),
			replace	=> true,
			ensure	=> present,
			require	=> Package[$packages] 
		} ->

		exec { "curl ${zabbix_repo_key} | apt-key add -":
			unless	=> "apt-key list | grep -i zabbix",
			path	=> "/bin:/sbin:/usr/bin:/usr/sbin",
		} ~>

		exec { "zabbix aptitude update":
			command		=> "aptitude update",
			path		=> "/bin:/sbin:/usr/bin:/usr/sbin",
			refreshonly	=> true,
		}

	}	
}
