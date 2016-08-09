#
# Cookbook Name:: nagios-cookbook
# Recipe:: nagios_nginx
#
# All rights reserved 
#

template '/usr/local/nagios/etc/servers/nginx.cfg' do 
		source 'nginx_server.cfg.erb'
		owner 'nagios'
		group 'nagios'
		mode 0664
		action :create
		variables(
			nginx_server_ip: node['nginx_server_ip'] 
		)

		notifies :reload, 'service[nagios]'   
end