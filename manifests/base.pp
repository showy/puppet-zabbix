class puppet-zabbix::base(
	$zabbix_agent_version='latest',
	$zabbix_repo_key="http://repo.zabbix.com/zabbix-official-repo.key",
	$zabbix_repo_url="http://repo.zabbix.com/zabbix/2.0/debian/",
	$zabbix_repo_sections=[ "main", "contrib","non-free"],
	$zabbix_repo_file="/etc/apt/sources.list.d/zabbix_repo.list"
) inherits puppet-zabbix::settings {

	# Establish relationships
	Class["puppet-zabbix::settings"] -> Class["puppet-zabbix::base"]


	# this->specific
	if ($support){
		case $operatingsystem {
			/(?i:debian)/: {
				case $lsbdistcodename {
					/(?i:wheezy|squeeze|sid)/: {
						$packages = [ "curl"] # This package list is required by resources in this file
						$zabbix_repo_file_erb = "debian_repo_file.erb"
					}
				}
			}
		}

		puppet-zabbix::functions::package_installer {$packages:} 

		file { $zabbix_repo_file:
			owner	=> "root",
			group 	=> "root",
			mode	=> 0644,
			content	=> template("${module_name}/base/${zabbix_repo_file_erb}"),
			replace	=> true,
			ensure	=> present,
			require	=> Package[$packages] 
		} ~>

		exec { "curl ${zabbix_repo_key} | apt-key add -":
			unless	=> "apt-key list | grep -i zabbix",
			path	=> "/bin:/sbin:/usr/bin:/usr/sbin",
		} ~>

		exec { "zabbix aptitude update":
			command		=> "aptitude update",
			path		=> "/bin:/sbin:/usr/bin:/usr/sbin",
			refreshonly	=> true,
		}

	} else {
		notify { "Operatingsystem/Distribution not supported": }
	}
}
