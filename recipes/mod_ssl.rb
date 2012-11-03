#
# Cookbook Name:: apache
# Recipe:: mod_ssl 
#
# Copyright 2008-2009, Opscode, Inc.
# Copyright (C) 2012, SecondMarket Labs, LLC.
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

unless node['rhapache']['listen_ports'].include?("443")
  node.set['rhapache']['listen_ports'] = node['rhapache']['listen_ports'] + ["443"]
end

package "mod_ssl" do
  action :install
end

file "#{node['rhapache']['dir']}/conf.d/ssl.conf" do
  action :delete
  backup false 
end

rhapache_module "ssl" do
  # nothing
end

