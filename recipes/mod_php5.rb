#
# Cookbook Name:: apache
# Recipe:: mod_php5 
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

case node[:platform]

when "redhat", "centos", "scientific"
  package "php package" do
    # TODO: Might want to give people a way to toggle what version of PHP they
    # actually want on CentOS... 5.1 or 5.3
    if node.platform_version.to_f < 6.0
      package_name "php53"
    else
      package_name "php"
    end
    action :install
  end

when "fedora"
  package "php package" do
     package_name "php"
     action :install
  end

end

# delete stock config
file "#{node[:apache][:dir]}/conf.d/php.conf" do
  action :delete
end

apache_module "php5" do
  case node['platform']
  when "redhat","centos","scientific","fedora"
    filename "libphp5.so"
  end
end

