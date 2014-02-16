#
# Cookbook Name:: vim
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "vim" do
	action :install
end

execute "vim setting" do
    command <<-EOH
        update-alternatives --set editor /usr/bin/vim.basic
    EOH
    user "root"
end
