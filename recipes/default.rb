#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright (C) 2012 SecondMarket Labs, LLC.
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

package "apache2" do
  package_name node[:apache][:package]
  action :install
end

service "apache2" do
  service_name "httpd"
  # If restarted/reloaded too quickly httpd has a habit of failing.
  # This may happen with multiple recipes notifying apache to restart - like
  # during the initial bootstrap.
  restart_command "/sbin/service httpd restart && sleep 1"
  reload_command "/sbin/service httpd reload && sleep 1"

  supports value_for_platform(
                              "redhat" => { "default" => [ :restart, :reload, :status ] },
                              "centos" => { "default" => [ :restart, :reload, :status ] },
                              "scientific" => { "default" => [ :restart, :reload, :status ] },
                              "fedora" => { "default" => [ :restart, :reload, :status ] },
                              "suse" => { "default" => [ :restart, :reload, :status ] },
                              "default" => { "default" => [:restart, :reload ] }
                              )
  action :enable
end

directory node[:apache][:log_dir] do
  mode 0755
  action :create
end

# installed by default, get rid of them
%w{ proxy_ajp auth_pam authz_ldap webalizer welcome }.each do |f|
  file "#{node[:apache][:dir]}/conf.d/#{f}.conf" do
    action :delete
    backup false
  end
end

# installed by default, get rid of them
file "#{node[:apache][:dir]}/conf.d/README" do
  action :delete
  backup false
end

# should already be on a RHEL/CentOS/Fedora system but never hurts to make sure
directory "#{node[:apache][:dir]}/conf.d" do
  action :create
  mode 0755
  owner "root"
  group node[:apache][:root_group]
end

directory node[:apache][:cache_dir] do
  action :create
  mode 0755
  owner "root"
  group node[:apache][:root_group]
end

template "httpd.conf" do
  path "#{node[:apache][:dir]}/conf/httpd.conf"
  source "httpd.conf.erb"
  owner "root"
  group node[:apache][:root_group]
  variables :apache_listen_ports => node[:apache][:listen_ports].map{|p| p.to_i}.uniq
  mode 0644
  notifies :restart, resources(:service => "apache2")
end

template "security" do
  path "#{node[:apache][:dir]}/conf.d/security.conf"
  source "security.conf.erb"
  owner "root"
  group node[:apache][:root_group]
  mode 0644
  backup false
  notifies :restart, resources(:service => "apache2")
end

template "charset" do
  path "#{node[:apache][:dir]}/conf.d/charset.conf"
  source "charset.conf.erb"
  owner "root"
  group node[:apache][:root_group]
  mode 0644
  backup false
  notifies :restart, resources(:service => "apache2")
end

unless node[:apache][:additional_modules].nil?
  node[:apache][:additional_modules].each do |mod|
    recipe_name = mod =~ /^mod_/ ? mod : "mod_#{mod}"
    include_recipe "apache2::#{recipe_name}"
  end
end

service "apache2" do
  action :start
end
