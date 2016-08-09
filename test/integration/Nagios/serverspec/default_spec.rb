require 'serverspec'

# Required by serverspec
set :backend, :exec


describe package('nodejs') do
  it { should be_installed }
end


describe package('openssl-devel') do
  it { should be_installed }
end


describe service('httpd') do
  it { should be_enabled }
  it { should be_running }
end

describe service('nagios') do
  it { should be_enabled }
  it { should be_running }
end

describe user('nagios') do
  it { should exist }
end

describe user('nagios') do
  it { should belong_to_group 'nagios' }
end


describe file('/usr/local/nagios/etc/cgi.cfg') do
  it { should be_file }
  it { should be_mode 664 }
  it { should be_owned_by 'nagios' }
  it { should be_grouped_into 'nagios' }
  it { should contain 'use_authentication= 0' }
  it { should contain 'authorized_for_system_information=nagiosadmin' }
  it { should contain 'main_config_file=/usr/local/nagios/etc/nagios.cfg' }
end

describe file('/usr/local/nagios/etc/servers/nginx.cfg') do
  it { should be_file }
  it { should be_mode 664 }
  it { should be_owned_by 'nagios' }
  it { should be_grouped_into 'nagios' }

  it { should contain 'define host {' }
  it { should contain 'use                             linux-server' }
  it { should contain 'host_name                       nginx-server' }
  it { should contain 'alias                           My nginx server' }
  it { should contain 'address                         192.168.50.202' }

  it { should contain 'define service {' }
  it { should contain 'use                             generic-service' }
  it { should contain 'service_description             PING' }
  it { should contain 'check_command                   check_ping!100.0,20%!500.0,60%' }

  it { should contain 'host_name                       nginx-server' }
  it { should contain 'service_description             SSH' }
  it { should contain 'check_command                   check_ssh' }

  it { should contain 'use                             generic-service' }
  it { should contain 'host_name                       nginx-server' }
end

describe file('/usr/local/nagios/etc/servers/redis.cfg') do
  it { should be_file }
  it { should be_mode 664 }
  it { should be_owned_by 'nagios' }
  it { should be_grouped_into 'nagios' }

  it { should contain 'define host {' }
  it { should contain 'use                             linux-server' }
  it { should contain 'host_name                       redis-server' }
  it { should contain 'alias                           My redis server' }
  it { should contain 'address                         192.168.50.201' }

  it { should contain 'define service {' }
  it { should contain 'use                             generic-service' }
  it { should contain 'service_description             PING' }
  it { should contain 'check_command                   check_ping!100.0,20%!500.0,60%' }

  it { should contain 'service_description             SSH' }
  it { should contain 'check_command                   check_ssh' }
end
