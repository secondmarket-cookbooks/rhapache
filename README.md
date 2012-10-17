Description
===========

This cookbook provides a complete Apache HTTPD configuration while respecting as much of the RedHat/CentOS layout as possible. While we have cribbed many features from Opscode's apache2 cookbook, we really dislike the a2*-style mechanism of doing things, so we have slimmed this down significantly to support only RedHat/CentOS/Fedora-style distributions.

We also take a different approach to the Opscode cookbook: we start with a richer base configuration onto which you can add additional modules. The "base" configuration is somewhere between a stripped-down Apache and RedHat's liberal defaults.

We have also disabled some of the "on-the-outer-edge" features of the Opscode cookbook, e.g. the mod_auth_openid support.

Requirements
============

## Cookbooks:

This cookbook doesn't have direct dependencies on other cookbooks. Depending on your OS configuration and security policy, you may need additional recipes or cookbooks for this cookbook's recipes to converge on the node. In particular, the following Operating System nuances may affect the behavior:

* yum cache outdate
* SELinux enabled
* IPtables
* Compile tools

## Platforms:

* Red Hat/CentOS/Scientific Linux/Fedora (RHEL Family)

### Notes for RHEL Family:

On Red Hat Enterprise Linux and derivatives, the EPEL repository may be necessary to install packages used in certain recipes. The `apache2::default` recipe, however, does not require any additional repositories. Opscode's `yum` cookbook contains a recipe to add the EPEL repository. See __Examples__ for more information.

Attributes
==========

This cookbook uses many attributes, broken up into a few different kinds.

Platform specific
-----------------

In order to support the broadest number of platforms, several attributes are determined based on the node's platform. See the attributes/default.rb file for default values in the case statement at the top of the file.

* `node['apache']['dir']` - Location for the Apache configuration
* `node['apache']['log_dir']` - Location for Apache logs
* `node['apache']['user']` - User Apache runs as
* `node['apache']['group']` - Group Apache runs as
* `node['apache']['binary']` - Apache httpd server daemon
* `node['apache']['icondir']` - Location for icons
* `node['apache']['cache_dir']` - Location for cached files used by Apache itself or recipes
* `node['apache']['pid_file']` - Location of the PID file for Apache httpd
* `node['apache']['lib_dir']` - Location for shared libraries

General settings
----------------

These are general settings used in recipes and templates. Default values are noted.

* `node['apache']['listen_ports']` - Ports that httpd should listen on. Default is an array of ports 80 and 443.
* `node['apache']['contact']` - Value for ServerAdmin directive. Default "ops@example.com".
* `node['apache']['timeout']` - Value for the Timeout directive. Default is 300.
* `node['apache']['keepalive']` - Value for the KeepAlive directive. Default is On.
* `node['apache']['keepaliverequests']` - Value for MaxKeepAliveRequests. Default is 100.
* `node['apache']['keepalivetimeout']` - Value for the KeepAliveTimeout directive. Default is 5.
* `node['apache']['default_modules']` - Array of module names. Can take "mod_FOO" or "FOO" as names, where FOO is the apache module, e.g. "`mod_status`" or "`status`".

The modules listed in `default_modules` will be included as recipes in `recipe[apache::default]`.

Prefork attributes
------------------

Prefork attributes are used for tuning the Apache HTTPD prefork MPM configuration.

* `node['apache']['prefork']['startservers']` - initial number of server processes to start. Default is 16.
* `node['apache']['prefork']['minspareservers']` - minimum number of spare server processes. Default 16.
* `node['apache']['prefork']['maxspareservers']` - maximum number of spare server processes. Default 32.
* `node['apache']['prefork']['serverlimit']` - upper limit on configurable server processes. Default 400.
* `node['apache']['prefork']['maxclients']` - Maximum number of simultaneous connections.
* `node['apache']['prefork']['maxrequestsperchild']` - Maximum number of request a child process will handle. Default 10000.

Worker attributes
-----------------

Worker attributes are used for tuning the Apache HTTPD worker MPM configuration.

* `node['apache']['worker']['startservers']` - Initial number of server processes to start. Default 4
* `node['apache']['worker']['maxclients']` - Maximum number of simultaneous connections. Default 1024.
* `node['apache']['worker']['minsparethreads]` - Minimum number of spare worker threads. Default 64
* `node['apache']['worker']['maxsparethreads]` - Maximum number of spare worker threads. Default 192.
* `node['apache']['worker']['maxrequestsperchild']` - Maximum number of requests a child process will handle.

Recipes
=======

Most of the recipes in the cookbook are for enabling Apache modules. Where additional configuration or behavior is used, it is documented below in more detail.

On RHEL Family distributions, certain modules ship with a config file with the package. The recipes here may delete those configuration files to ensure they don't conflict with the settings from the cookbook.

mod\_php5
--------

Simply installs the appropriate package on Debian, Ubuntu and ArchLinux.

On Red Hat family distributions including Fedora, the php.conf that comes with the package is removed. On RHEL platforms less than v6, the `php53` package is used.

mod\_ssl
--------

Besides installing and enabling `mod_ssl`, this recipe will append port 443 to the `node['apache']['listen_ports']` attribute array and update the ports.conf.

License and Authors
===================

## SecondMarket authors:

Author:: Chris Ferry <CFerry@secondmarket.com>
Author:: Julian Dunn <JDunn@secondmarket.com>

## Original Opscode cookbook authors:

Author:: Adam Jacob <adam@opscode.com>
Author:: Joshua Timberman <joshua@opscode.com>
Author:: Bryan McLellan <bryanm@widemile.com>
Author:: Dave Esposito <esposito@espolinux.corpnet.local>
Author:: David Abdemoulaie <github@hobodave.com>
Author:: Edmund Haselwanter <edmund@haselwanter.com>
Author:: Eric Rochester <err8n@virginia.edu>
Author:: Jim Browne <jbrowne@42lines.net>
Author:: Matthew Kent <mkent@magoazul.com>
Author:: Nathen Harvey <nharvey@customink.com>
Author:: Ringo De Smet <ringo.de.smet@amplidata.com>
Author:: Sean OMeara <someara@opscode.com>
Author:: Seth Chisamore <schisamo@opscode.com>
Author:: Gilles Devaux <gilles@peerpong.com>

Copyright:: 2009-2011, Opscode, Inc
Copyright:: 2011, Atriso
Copyright:: 2011, CustomInk, LLC.
Copyright:: 2012, SecondMarket Labs, LLC.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
