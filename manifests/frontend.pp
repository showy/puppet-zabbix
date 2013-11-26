class puppet-zabbix::frontend(
	$zabbix_frontend_pkg					= 'zabbix-frontend-php',
	$zabbix_frontend_pkg_version			= 'present',
	$zabbix_frontend_pkg_others				= [],
	$zabbix_frontend_webserver				= 'apache2',
	$zabbix_frontend_webserver_pkg			= 'apache2-mpm-prefork',
	$zabbix_frontend_webserver_pkg_others	= [ 'php5-pgsql' ],
	$zabbix_frontend_webservice_name		= 'apache2',
	$zabbix_frontend_webservice_pattern		= 'apache2',
	$zabbix_frontend_webservice_hasstatus	= true,
	$zabbix_frontend_config 				= '/etc/zabbix/apache.conf',
	$zabbix_frontend_config_template		= 'zabbix_frontend_apache_conf.erb',
	$zabbix_frontend_apache_conf_alias		= 'zabbix',
	$zabbix_frontend_apache_conf_rootdir	= '/usr/share/zabbix/',
	$zabbix_php_max_execution_time			= '300',
	$zabbix_php_memory_limit				= '128M',
	$zabbix_php_post_max_size				= '16M',
	$zabbix_php_upload_max_filesize			= '2M',
	$zabbix_php_max_input_time				= '300',
	$zabbix_php_timezone					= 'Ecuador/Guayaquil',
	$zabbix_frontend_conf_php 				= '/etc/zabbix/web/zabbix.conf.php',
	$zabbix_frontend_conf_php_template		= 'zabbix_conf_php.erb',
	$zabbix_frontend_conf_php_dbtype		= 'POSTGRESQL',
	$zabbix_frontend_conf_php_dbserver		= 'localhost',
	$zabbix_frontend_conf_php_server_port	= '5432',
	$zabbix_frontend_conf_php_db 			= 'zabbix',
	$zabbix_frontend_conf_php_dbuser		= 'zabbix',
	$zabbix_frontend_conf_php_dbpass		= 'zabbix',
	$zabbix_frontend_conf_php_zbxserver		= 'localhost',
	$zabbix_frontend_conf_php_zbxserver_port	= '10051',
) inherits puppet-zabbix::settings {

	# Establishing order
	Class['puppet-zabbix::settings'] -> Class['puppet-zabbix::frontend']

	# One more time. Do i support this OS?

	if ($support_os_server) {
		puppet-zabbix::functions::package_installer { $zabbix_frontend_webserver_pkg: } ->
		puppet-zabbix::functions::package_installer { $zabbix_frontend_webserver_pkg_others: } ->
		puppet-zabbix::functions::package_installer { $zabbix_frontend_pkg: version => $zabbix_frontend_pkg_version } ->
		puppet-zabbix::functions::package_installer { $zabbix_frontend_pkg_others: } ->

		file { $zabbix_frontend_config:
			owner		=> 'root',
			group 		=> 'root',
			mode		=> 0644,
			content		=> template("${module_name}/frontend/${zabbix_frontend_config_template}"),
			replace		=> true,
			ensure		=> present,
			notify		=> Service[$zabbix_frontend_webservice_name],
		} ->

		file { $zabbix_frontend_conf_php:
			owner		=> 'www-data',
			group 		=> 'www-data',
			mode 		=> '0644',
			content		=> template("${module_name}/frontend/${zabbix_frontend_conf_php_template}"),
			replace		=> true,
			ensure		=> present,
			require		=> Package[$zabbix_frontend_pkg],
		}

		if (!defined(Service[$zabbix_frontend_webservice_name])) {
			service { $zabbix_frontend_webservice_name: 
				hasstatus 	=> $zabbix_frontend_webservice_hasstatus,
				ensure		=> running,
				pattern 	=> $zabbix_frontend_webservice_pattern,
			}
		}


	} else {
		notify { "Do not have support for ${operatingsystem}": name => "Alert frontend install"}
	}

	
}