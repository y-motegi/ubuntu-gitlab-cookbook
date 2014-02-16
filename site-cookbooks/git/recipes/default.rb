#
# Cookbook Name:: git
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{
    libcurl4-openssl-dev
    libexpat1-dev
    gettext
    libz-dev
    libssl-dev
    build-essential
}.each do |pkgname|
    package "#{pkgname}" do
        action :install
    end
end

execute "git download" do
    command <<-EOH
        wget https://git-core.googlecode.com/files/git-1.8.4.1.tar.gz
        tar xzf git-1.8.4.1.tar.gz
        rm -rf git-1.8.4.1.tar.gz
    EOH
    cwd "/tmp"
    user "root"
end

execute "git install" do
    command <<-EOH
        make prefix=/usr/local all
        make prefix=/usr/local install 
    EOH
    cwd "/tmp/git-1.8.4.1"
    user "root"
end
