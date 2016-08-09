#
# Cookbook Name:: nagios-cookbook
# Recipe:: nagios_redis
#
# All rights reserved 
#

template '/usr/local/nagios/etc/servers/redis.cfg' do 
		source 'redis_server.cfg.erb'
		owner 'nagios'
		group 'nagios'
		mode 0664
		action :create
		variables(
			redis_server_ip: node['redis_server_ip'] 
		)

		notifies :reload, 'service[nagios]'   
end