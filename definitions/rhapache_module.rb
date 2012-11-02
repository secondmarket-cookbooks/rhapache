#
# Cookbook Name:: apache
# Definition:: apache_module
#
# Copyright 2012, SecondMarket Labs, LLC.
# Copyright 2008-2009, Opscode, Inc.
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
#
# Differs from the Opscode cookbook in that you always need a basic file,
# even if there are no config directives beyond just enabling the module.
# This simplifies the "definitions", however, such that you need only one, apache_module.

define :rhapache_module, :enable => true do

  params[:filename] = params[:filename] || "mod_#{params[:name]}.so"
  params[:module_path] = params[:module_path] || "#{node['rhapache']['libexecdir']}/#{params[:filename]}"
  
  template "#{node[:rhapache][:dir]}/conf.d/mod_#{params[:name]}.conf" do
    source "mods/#{params[:name]}.conf.erb"
    notifies :restart, resources(:service => "apache2")
    mode 0644
    variables( :enable => params[:enable], :name => params[:name], :module_path => params[:module_path])
  end
end

