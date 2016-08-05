#
# Cookbook Name:: nagios-cookbook
# Recipe:: nagios_plugin
#
# All rights reserved 
#


remote_file '/home/vagrant/nagios-plugins-2.1.1.tar.gz' do 
	source 'http://nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz'
	action :create_if_missing
end

unless Dir.exists?('/home/vagrant/nagios-plugins-2.1.1')

	execute 'Extract nagios-plugins-2.1.1.tar.gz' do 
		cwd '/home/vagrant'
		command 'tar xvf nagios-plugins-*.tar.gz'
		action :run
	end


	execute 'Before building, configure it' do 
		cwd '/home/vagrant/nagios-plugins-2.1.1'
		command './configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl'
		action :run
	end

	execute 'Compile and install' do 
		cwd '/home/vagrant/nagios-plugins-2.1.1'
		command 'make'
		action :run
	end

	execute 'Compile and install' do 
		cwd '/home/vagrant/nagios-plugins-2.1.1'
		user 'root'
		command 'make install'
		action :run
	end

end

remote_file '/home/vagrant/nrpe-2.15.tar.gz' do 
	source 'http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz'
	action :create_if_missing
end

unless Dir.exists?('/home/vagrant/nrpe-2.15')

	execute 'Extract nrpe-2.15.tar.gz' do 
		cwd '/home/vagrant'
		command 'tar xvf nrpe-*.tar.gz'
		action :run
	end


	execute 'Configure it' do 
		cwd '/home/vagrant/nrpe-2.15'
		command './configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu'
		action :run
	end

	execute 'Build it' do 
		cwd '/home/vagrant/nrpe-2.15'
		command 'make all'
		action :run
	end

	execute 'Install it' do 
		cwd '/home/vagrant/nrpe-2.15'
		user 'root'
		command 'make install && make install-xinetd && make install-daemon-config'
		action :run
	end

	template '/etc/xinetd.d/nrpe' do 
		source 'nrpe.erb'
		owner 'root'
		group 'root'
		mode '0644'
		action :create
		variables(
			node_ip: node['ipaddress']
		)  
	end

	service 'xinetd' do 
		action [ :enable, :restart]
	end

end
