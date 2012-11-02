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

set[:rhapache][:root_group]  = "root"

# Where the various parts of apache are
set[:rhapache][:package] = "httpd"
set[:rhapache][:dir]     = "/etc/httpd"
set[:rhapache][:log_dir] = "/var/log/httpd"
set[:rhapache][:error_log] = "error.log"

set[:rhapache][:binary]  = "/usr/sbin/httpd"
set[:rhapache][:icondir] = "/var/www/icons"
set[:rhapache][:cache_dir] = "/var/cache/httpd"
if node.platform_version.to_f >= 6 then
  set[:rhapache][:pid_file] = "/var/run/httpd/httpd.pid"
else
  set[:rhapache][:pid_file] = "/var/run/httpd.pid"
end
set[:rhapache][:lib_dir] = node[:kernel][:machine] =~ /^i[36]86$/ ? "/usr/lib/httpd" : "/usr/lib64/httpd"
set[:rhapache][:libexecdir] = "#{set[:rhapache][:lib_dir]}/modules"

case platform
when "redhat","centos","scientific","fedora"
  set[:rhapache][:user]    = "apache"
  set[:rhapache][:group]   = "apache"
when "suse"
  # XXX pretty sure this is the case but someone on a SUSE box should check
  set[:rhapache][:user]    = "wwwrun"
  set[:rhapache][:group]   = "wwwrun"
end

###
# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
default[:rhapache][:listen_ports] = [ "80","443" ]
default[:rhapache][:contact] = "ops@example.com"
default[:rhapache][:timeout] = 300
default[:rhapache][:keepalive] = "On"
default[:rhapache][:keepaliverequests] = 100
default[:rhapache][:keepalivetimeout] = 5
default[:rhapache][:extendedstatus] = "Off"

# Security
default[:rhapache][:servertokens] = "Prod"
default[:rhapache][:serversignature] = "Off"
default[:rhapache][:traceenable] = "Off"

# Prefork Attributes
default[:rhapache][:prefork][:startservers] = 16
default[:rhapache][:prefork][:minspareservers] = 16
default[:rhapache][:prefork][:maxspareservers] = 32
default[:rhapache][:prefork][:serverlimit] = 400
default[:rhapache][:prefork][:maxclients] = 400
default[:rhapache][:prefork][:maxrequestsperchild] = 10000

# Worker Attributes
default[:rhapache][:worker][:startservers] = 4
default[:rhapache][:worker][:maxclients] = 1024
default[:rhapache][:worker][:minsparethreads] = 64
default[:rhapache][:worker][:maxsparethreads] = 192
default[:rhapache][:worker][:threadsperchild] = 64
default[:rhapache][:worker][:maxrequestsperchild] = 0

# Additional modules to load by default
default[:rhapache][:additional_modules] = nil
