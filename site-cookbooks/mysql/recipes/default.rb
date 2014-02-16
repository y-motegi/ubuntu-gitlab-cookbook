#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


%w{
    mysql-server
    mysql-client
    libmysqlclient-dev 
}.each do |pkgname|
    package "#{pkgname}" do
        action :install
    end
end

execute "mysql-create-user" do
    command "/usr/bin/mysql -u root < /tmp/grants.sql"
    action :nothing
end

template "/tmp/grants.sql" do
    owner "root"
    group "root"
    mode "0600"
    notifies :run, "execute[mysql-create-user]", :immediately
end
