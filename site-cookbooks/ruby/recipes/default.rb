#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/tmp/ruby" do
	owner "root"
	group "root"
	action :create
	recursive true
end

execute "ruby download" do
    command <<-EOH
        wget ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p353.tar.gz
        tar xzf ruby-2.0.0-p353.tar.gz
        rm -rf ruby-2.0.0-p353.tar.gz
    EOH
    cwd "/tmp/ruby"
    user "root"
end

execute "ruby install" do
    command <<-EOH
        /tmp/ruby/ruby-2.0.0-p353/configure --disable-install-rdoc
        make
        make install
        gem install bundler --no-ri --no-rdoc
    EOH
    cwd "/tmp/ruby/ruby-2.0.0-p353"
    user "root"
end
