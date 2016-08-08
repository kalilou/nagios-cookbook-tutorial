#
# Cookbook Name:: nagios-cookbook
# Recipe:: lamp_server
#
# All rights reserved 
#


package 'Install epel release repo' do 
	package_name 'epel-release'
	action :install
end

package 'Install httpd package' do 
	package_name 'httpd'
	action :install
end


service 'httpd' do 
	service_name 'httpd'
	action [ :enable, :start ]
end

package 'Install php package' do 
	package_name 'php'
	action :install
	notifies :restart, 'service[httpd]'
end