#
# Cookbook Name:: sample
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
service "gitlab" do
       	action [:enable, :start]
	reload_command '/etc/init.d/gitlab reload'
	restart_command '/etc/init.d/gitlab restart'
	service_name 'gitlab'
	start_command '/etc/init.d/gitlab start'
	status_command '/etc/init.d/gitlab status'
	stop_command '/etc/init.d/gitlab stop'
	supports :status => true, :restart => true
end
