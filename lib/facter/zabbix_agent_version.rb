Facter.add("zabbix_agent_version") do
	zabbix_agent_bin = %{zabbix_agent}
	undefined_version = '0.0.0'
	if zabbix_agent_bin
		result = Facter::Util::Resolution.exec( [ zabbix_agent_bin , "-V"].join(" ") )
		setcode do
			if result.nil? or result.size == 0
				return undefined_version
			else
				result.split.each do |e|
					return e.gsub!(/[a-zA-z]/,'') if e[/\d+\.\d+/]
				end
			end
			# If I have come this far, then is something wrong
			return undefined_version
		end
	end
end