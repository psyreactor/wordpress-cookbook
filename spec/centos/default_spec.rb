require_relative '../spec_helper'

describe 'wordpress::default on Centos 6.5' do
  let(:chef_run) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '6.5'
      ) do |node|
      node.set[:wordpress][:version] = '3.9.1'
      node.set[:wordpress][:domain] = 'myblog.com'
    end.converge('wordpress::default')
  end

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/var/www/html/wp-secrets.php').and_return(true)
    allow(File).to receive(:read).and_call_original
    allow(File).to receive(:read).with('/var/www/html/wp-secrets.php').and_return(true)
    stub_command('which php').and_return(true)
    stub_command("mysql --user=wordpress --password=password wordpress -e \"SHOW TABLES; \" | grep wp_options").and_return(false)
    stub_command('/usr/sbin/httpd -t').and_return(true)
  end

  it 'includes depends recipes' do
    expect(chef_run).to include_recipe('apache2::default')
    expect(chef_run).to include_recipe('apache2::mod_php5')
    expect(chef_run).to include_recipe('mysql::server')
    expect(chef_run).to include_recipe('php::default')
    expect(chef_run).to include_recipe('database::mysql')
  end

  it 'installs a php package' do
    expect(chef_run).to install_package('php-imap')
    expect(chef_run).to install_package('php-mysql')
    expect(chef_run).to install_package('php-mbstring')
  end

  it 'download wordpress package' do
    expect(chef_run).to create_remote_file_if_missing("#{Chef::Config[:file_cache_path]}/wordpress-3.9.1.tar.gz")
  end

  it 'extract wordpress' do
    expect(chef_run).to run_execute('worpress_extract')
  end

  it 'create database wordpress' do
    expect(chef_run).to create_mysql_database('wordpress')
  end

  it 'create user database wordpress' do
    expect(chef_run).to grant_mysql_database_user('wordpress')
  end

  it 'created wp-config.php' do
    expect(chef_run).to create_template('/var/www/html/wordpress/wp-config.php')
  end

  it 'runs a ruby_block salt wordpress' do
    expect(chef_run).to run_ruby_block('secrets_wordpress')
  end

  it 'add to hosts file wordpress domain' do
    expect(chef_run).to append_hostsfile_entry('127.0.0.1').with_hostname('myblog.com')
  end

  it 'install wordpress' do
    expect(chef_run).to run_execute('wordpress_install')
  end

end
