#
# Cookbook Name:: nagios-cookbook
# Recipe:: redis
#
# All rights reserved 
#

package 'epel-release'

package 'nrpe'
package 'redis'
package 'nagios-plugins-all'

service 'redis' do 
	action [ :enable, :start ]
end

template '/etc/nagios/nrpe.cfg' do 
		source 'redis_nrpe.cfg.erb'
		owner 'nagios'
		group 'nagios'
		mode 0664
		action :create
		variables(
			nagios_server_ip: node['nagios_server_ip'] 
		)  
end



