#
# Cookbook Name:: nagios-cookbook
# Recipe:: server
#
# All rights reserved 
#

package 'epel-release'


['gcc', 'glibc', 'glibc-common', 'gd', 'gd-devel', 'gcc-c++','make', 'net-snmp', 'openssl-devel', 'xinetd', 'unzip', 'nodejs', 'npm'].each do |pkg|
	package pkg do 
		action :install
	end
end

package 'python-devel'

execute 'Install nagios-redis' do 
	command 'npm install -g nagios-redis'
	action :run
end




user 'nagios' do 
	comment 'A nagios user'
	shell '/bin/bash'
end


group 'nagios' do 
	action :create 
	members ['nagios', 'apache']
end

# Install nagios plugin check_nginx for monitoring nginx
cookbook_file '/usr/local/nagios/libexec/check_nginx' do
 	source 'check_nginx'
  	owner 'nagios'
  	group 'nagios'
  	mode 0664
  	action :create
end 

remote_file '/home/vagrant/nagios-4.1.1.tar.gz' do 
	source 'https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz'
	action :create_if_missing
end

unless Dir.exists?('/home/vagrant/nagios-4.1.1')

	execute 'Extract the nagios-4.1.1.tar.gz' do 
		cwd '/home/vagrant'
		command 'tar xvf nagios-*.tar.gz'
		action :run
	end


	execute 'Before building, configure it' do 
		cwd '/home/vagrant/nagios-4.1.1'
		command './configure --with-command-group=nagios'
		action :run
	end

	execute 'Compile it' do 
		cwd '/home/vagrant/nagios-4.1.1'
		command 'make all'
		action :run
	end

	execute 'Install nagios' do
		cwd '/home/vagrant/nagios-4.1.1'
		user 'root'
		command 'make install && make install-commandmode'
	end

	execute 'Install init script' do
		cwd '/home/vagrant/nagios-4.1.1'
		user 'root'
		command 'make install-init'
	end

	execute 'Install configs' do
		cwd '/home/vagrant/nagios-4.1.1'
		user 'root'
		command 'make install-config && make install-webconf'
	end

end

