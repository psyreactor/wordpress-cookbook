# Cookbook Name:: worpress
# Recipe:: default
#
# Copyright 2014, Mariani Lucas
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe 'apache2::default'
include_recipe 'apache2::mod_php5'
include_recipe 'mysql::server'
include_recipe 'php::default'
include_recipe 'database::mysql'

apache_site 'default' do
  enable true
end

%w(php-imap php-mysql php-mbstring).each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:wordpress][:filename]}.tar.gz" do
  action :create_if_missing
  owner 'root'
  group 'root'
  mode '0644'
  source node[:wordpress][:url]
end

execute 'worpress_extract' do
  user 'root'
  cwd Chef::Config[:file_cache_path]
  command "tar vfxz #{node[:wordpress][:filename]}.tar.gz -C #{node[:wordpress][:destination]}"
  action :run
  not_if { ::Dir.exist?("#{Chef::Config[:file_cache_path]}/wordpress") }
end

mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node[:mysql][:server_root_password]
}

mysql_database node[:wordpress][:db_name] do
  connection mysql_connection_info
  action :create
end

mysql_database_user node[:wordpress][:db_user] do
  connection mysql_connection_info
  password node[:wordpress][:db_password]
  database_name node[:wordpress][:db_name]
  host '%'
  privileges [:all]
  action :grant
end

wp_secrets = "#{Chef::Config[:file_cache_path]}/wp-secrets.php"

if File.exist?(wp_secrets)
  salt_data = File.read(wp_secrets)
else
  require 'open-uri'
  salt_data = open('https://api.wordpress.org/secret-key/1.1/salt/').read
  open(wp_secrets, 'wb') do |file|
    file << salt_data
  end
end

template "#{node[:wordpress][:destination]}/wordpress/wp-config.php" do
  source 'wp-config.php.erb'
  mode 0755
  owner 'root'
  group 'root'
  variables(
    :database        => node[:wordpress][:db_name],
    :user            => node[:wordpress][:db_user],
    :password        => node[:wordpress][:db_password],
    :salt            => salt_data
  )
end

execute 'wordpress_install' do
  command "curl -d \"weblog_title=#{node[:wordpress][:title]}&user_name=#{node[:wordpress][:username]}&admin_password=#{node[:wordpress][:password]}&admin_password2=#{node[:wordpress][:password]}&admin_email=#{node[:wordpress][:mail]}\" http://localhost/wordpress/wp-admin/install.php?step=2"
  action :run
  not_if "mysql --user=#{node[:wordpress][:db_user]} --password=#{node[:wordpress][:db_password]} #{node[:wordpress][:db_name]} -e \"SHOW TABLES; \" | grep wp_options"
end
