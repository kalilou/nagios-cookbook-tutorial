#
# Cookbook Name:: nagios-cookbook
# Recipe:: default
#
# All rights reserved 
#

include_recipe 'nagios-cookbook::lamp_server'
include_recipe 'nagios-cookbook::server'
include_recipe 'nagios-cookbook::nagios_plugin'


# Create a directory server which will store
# every server for monitoring
directory '/usr/local/nagios/etc/servers' do 
	mode 0755
    owner 'nagios'
    group 'nagios'
    recursive true
    action :create
end

template '/usr/local/nagios/etc/objects/contacts.cfg' do 
		source 'contacts.cfg.erb'
		owner 'nagios'
		group 'nagios'
		mode 0664
		action :create
		variables(
			contact_info: node['contact_info']
		)  
end

template '/usr/local/nagios/etc/cgi.cfg' do 
		source 'cgi.cfg.erb'
		owner 'nagios'
		group 'nagios'
		mode 0664
		action :create
		variables(
			auth_nagios: node['auth_nagios'] 
		)  
end

# This is just for this tutorial, otherwise use the databag 
# to store this confidential info
htpasswd '/usr/local/nagios/etc/htpasswd.users' do
  user "nagiosadmin"
  password "your_pasword"
end


cookbook_file '/usr/local/nagios/etc/objects/commands.cfg' do
 	source 'commands.cfg'
  	owner 'nagios'
  	group 'nagios'
  	mode 0664
  	action :create
end

cookbook_file '/etc/httpd/conf.d/nagios.conf' do
 	source 'nagios.conf'
  	owner 'root'
  	group 'root'
  	mode 0664
  	action :create
  	notifies :restart, 'service[httpd]'
end


service 'nagios' do 
	action [ :enable, :restart]
end

include_recipe 'nagios-cookbook::nagios_redis'

