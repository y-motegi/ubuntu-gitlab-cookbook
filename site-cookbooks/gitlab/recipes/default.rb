#
# Cookbook Name:: gitlab
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


#execute "gitlab-init" do
#    command <<-EOH
#        sudo adduser --disabled-login --gecos 'GitLab' git	
#    EOH
#end
user 'git' do
    comment  'Gitlab'
    home     '/home/git'
    password nil
    supports :manage_home => true
    action   [:create, :manage]
end

%w{
    build-essential
    zlib1g-dev
    libyaml-dev
    libssl-dev
    libgdbm-dev
    libreadline-dev
    libncurses5-dev
    libffi-dev
    curl
    openssh-server
    redis-server
    checkinstall
    libxml2-dev
    libxslt-dev
    libcurl4-openssl-dev
    libicu-dev
    logrotate 
}.each do |pkgname|
    package "#{pkgname}" do
        action :install
    end
end


execute "git shell clone" do
    command <<-EOH
        git clone https://github.com/gitlabhq/gitlab-shell.git
    EOH
    cwd "/home/git"
    user "git"
end

execute "git shell checkout" do
    command <<-EOH
        git checkout v1.7.0
    EOH
    cwd "/home/git/gitlab-shell"
    user "git"
end

template "/home/git/gitlab-shell/config.yml" do
	source "gitlab-config.erb"
	group "git"
	owner "git"
	mode "0664"
        variables(
        :gitlab_url => node['gitlab']['url']
        )
end

execute "git shell install" do
    command <<-EOH
        /home/git/gitlab-shell/bin/install
    EOH
    cwd "/home/git/gitlab-shell"
    user "git"
end

execute "gitlab clone" do
    command <<-EOH
        git clone https://github.com/gitlabhq/gitlabhq.git gitlab
    EOH
    cwd "/home/git"
    user "git"
end

execute "gitlab checkout" do
    command <<-EOH
	git checkout 6-0-stable
	chown -R git log/
	chown -R git tmp/
	chmod -R u+rwX log/
	chmod -R u+rwX tmp/
    EOH
    cwd "/home/git/gitlab"
    user "git"
end

%w{
	/home/git/gitlab-satellites/
	/home/git/gitlab/tmp/pids/
	/home/git/gitlab/tmp/sockets/
	/home/git/gitlab/public/uploads/
}.each do |dir|
    directory "#{dir}" do
	owner "git"
	group "git"
	mode "0775"
	action :create
	recursive true
    end
end

#execute "gitlab init" do
#    command <<-EOH
#        git config --global user.name "GitLab"
#        git config --global user.email "gitlab@localhost"
#        git config --global core.autocrlf input
#    EOH
#    cwd "/home/git/gitlab"
#    user "git"
#end

template "/home/git/gitlab/config/gitlab.yml" do
	source "gitlab.yml.erb"
	group "git"
	owner "git"
	mode "0664"
        variables(
        :gitlab_url => node['gitlab']['url']
        )
end

template "/home/git/gitlab/config/unicorn.rb" do
	source "unicorn.rb.erb"
	group "git"
	owner "git"
	mode "0664"
end

template "/home/git/gitlab/config/database.yml" do
	source "database.yml.erb"
	group "git"
	owner "git"
	mode "0660"
end

execute "gem install" do
    command <<-EOH
        gem install raphael-rails -v '2.1.0'
    EOH
    cwd "/home/git/gitlab"
    user "root"
end
execute "dundle install" do
    command <<-EOH
        bundle install --deployment --without development test postgres aws 
    EOH
    cwd "/home/git/gitlab"
    user "git"
end

execute "database init" do
    command <<-EOH
        bundle exec rake gitlab:setup RAILS_ENV=production force=yes 
    EOH
    cwd "/home/git/gitlab"
    user "git"
end

template "/etc/init.d/gitlab" do
	source "gitlab.erb"
	group "root"
	owner "root"
	mode "0755"
end

execute "gitlab auto start" do
    command <<-EOH
        update-rc.d gitlab defaults 21
    EOH
    user "root"
end

service "redis-server" do
	supports :status => true, :restart => true
       	action [:enable, :start]
end

service "gitlab" do
	supports :status => true, :restart => true
       	action [:enable, :start]
end
