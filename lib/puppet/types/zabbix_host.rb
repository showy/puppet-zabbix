Puppet::Type.newtype(:zabbix_host) do
	@doc = <<-EOF
		Models a host in the zabbix server daemon.
	EOF

	ensurable

	newparam(:name) do
		desc "Name of resource"
	end

	newproperty(:name) do
		desc "Name of the host in zabbix"
		validate do |value|
			unless value =~ /^\w+$/
				raise ArgumentError, "%s is not a valid hostname" % value
			end
		end
	end

	newproperty(:visible_name) do
		desc "Visible name of the host in zabbix"
	end

	newproperty(:ipaddress) do
		desc "IPAddress of the host"
		validate do |value|
			unless value =~ /^\d+\.\d+\.\d+\.\d+$/
				raise ArgumentError, "%s is not a valid ipaddress" % value
			end
		end
	end

	newproperty(:zabbix_server) do
		desc "The zabbix server to perform the operation"
	end

	newproperty(:zabbix_username) do
		desc "The username used for authentication"
	end

	newproperty(:zabbix_password) do
		desc "The password used for authentication"
	end


end