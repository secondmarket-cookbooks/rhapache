#
# Cookbook Name:: apache
# Attributes:: default
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
#

set[:apache][:root_group]  = "root"

# Where the various parts of apache are
set[:apache][:package] = "httpd"
set[:apache][:dir]     = "/etc/httpd"
set[:apache][:log_dir] = "/var/log/httpd"
set[:apache][:error_log] = "error.log"

set[:apache][:binary]  = "/usr/sbin/httpd"
set[:apache][:icondir] = "/var/www/icons"
set[:apache][:cache_dir] = "/var/cache/httpd"
if node.platform_version.to_f >= 6 then
  set[:apache][:pid_file] = "/var/run/httpd/httpd.pid"
else
  set[:apache][:pid_file] = "/var/run/httpd.pid"
end
set[:apache][:lib_dir] = node[:kernel][:machine] =~ /^i[36]86$/ ? "/usr/lib/httpd" : "/usr/lib64/httpd"
set[:apache][:libexecdir] = "#{set[:apache][:lib_dir]}/modules"

case platform
when "redhat","centos","scientific","fedora"
  set[:apache][:user]    = "apache"
  set[:apache][:group]   = "apache"
when "suse"
  # XXX pretty sure this is the case but someone on a SUSE box should check
  set[:apache][:user]    = "wwwrun"
  set[:apache][:group]   = "wwwrun"
end

###
# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
default[:apache][:listen_ports] = [ "80","443" ]
default[:apache][:contact] = "ops@example.com"
default[:apache][:timeout] = 300
default[:apache][:keepalive] = "On"
default[:apache][:keepaliverequests] = 100
default[:apache][:keepalivetimeout] = 5
default[:apache][:extendedstatus] = "Off"

# Security
default[:apache][:servertokens] = "Prod"
default[:apache][:serversignature] = "Off"
default[:apache][:traceenable] = "Off"

# Prefork Attributes
default[:apache][:prefork][:startservers] = 16
default[:apache][:prefork][:minspareservers] = 16
default[:apache][:prefork][:maxspareservers] = 32
default[:apache][:prefork][:serverlimit] = 400
default[:apache][:prefork][:maxclients] = 400
default[:apache][:prefork][:maxrequestsperchild] = 10000

# Worker Attributes
default[:apache][:worker][:startservers] = 4
default[:apache][:worker][:maxclients] = 1024
default[:apache][:worker][:minsparethreads] = 64
default[:apache][:worker][:maxsparethreads] = 192
default[:apache][:worker][:threadsperchild] = 64
default[:apache][:worker][:maxrequestsperchild] = 0

# Additional modules to load by default
default[:apache][:additional_modules] = nil
