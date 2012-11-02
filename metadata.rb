maintainer       "SecondMarket Labs, LLC"
maintainer_email "systems@secondmarket.com"
license          "All rights reserved"
description      "Installs and configures all aspects of apache2 using RedHat/CentOS style"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"
recipe           "default", "Nothing - use server"
recipe           "server", "Installs Apache HTTPD"
recipe           "mod_deflate", "Installs mod_deflate"
recipe           "mod_php5", "Installs PHP"
recipe           "mod_ssl", "Installs and enables SSL"
recipe           "mod_wsgi", "Installs mod_wsgi for Python applications"

%w{ fedora redhat centos }.each do |os|
  supports os
end

%w{ php yum }.each do |cb|
  depends cb
end
