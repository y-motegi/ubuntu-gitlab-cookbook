#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


package "nginx" do
	package_name "nginx"
	action :install
end

template "/etc/nginx/sites-available/gitlab" do
	source "gitlab.erb"
	group "root"
	owner "root"
	mode "0644"
        variables(
        :gitlab_url => node['gitlab']['url']
        )
end

execute "link nginx gitlab" do
    command <<-EOH
        ln -s /etc/nginx/sites-available/gitlab /etc/nginx/sites-enabled/gitlab 
    EOH
    user "root"
end

service "nginx" do
	supports :status => true, :restart => true
       	action [:enable, :start]
end
