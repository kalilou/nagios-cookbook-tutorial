#
# Cookbook Name:: nagios-cookbook
# Recipe:: default
#
# All rights reserved 
#



# Install epel-release repo 
package 'epel-release'

# Install nginx 
package 'nginx'

package 'nrpe'
package 'nagios-plugins-all'


template '/etc/nagios/nrpe.cfg' do 
		source 'nginx_nrpe.cfg.erb'
		owner 'nagios'
		group 'nagios'
		mode 0664
		action :create
		variables(
			nagios_server_ip: node['nagios_server_ip'] 
		)  
end

cookbook_file '/etc/nginx/conf.d/status.conf' do
 	source 'nginx_status.conf'
  	owner 'nginx'
  	group 'nginx'
  	mode 0664
  	action :create
end



# Enable and start nginx 
service 'nginx' do 
	action [ :enable, :start ]
end

service 'nrpe' do 
	action [ :enable, :start ]
end