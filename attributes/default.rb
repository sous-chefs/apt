default[:rackspace_apt][:config][:acng][:CacheDir][:value] = "/var/cache/apt-cacher-ng"
default[:rackspace_apt][:config][:acng][:LogDir][:value] = "/var/log/apt-cacher-ng"
default[:rackspace_apt][:config][:acng][:Port][:value] = "3142"
default[:rackspace_apt][:config][:acng][:Port][:comment] = "this is what you connect to."
default[:rackspace_apt][:config][:acng][:'Remap-debrep'][:value] = "file:deb_mirror*.gz /debian ; file:backends_debian"
default[:rackspace_apt][:config][:acng][:'Remap-uburep'][:value] = "file:ubuntu_mirrors /ubuntu ; file:backends_ubuntu"
default[:rackspace_apt][:config][:acng][:'Remap-debvol'][:value] = "file:debvol_mirror*.gz /debian-volatile ; file:backends_debvol"
default[:rackspace_apt][:config][:acng][:'Remap-cygwin'][:value] = "file:cygwin_mirrors /cygwin"
default[:rackspace_apt][:config][:acng][:'Remap-sfnet'][:value] = "file:sfnet_mirrors"
default[:rackspace_apt][:config][:acng][:'Remap-alxrep'][:value] = "file:archlx_mirrors /archlinux"
default[:rackspace_apt][:config][:acng][:'Remap-fedora'][:value] = "file:fedora_mirrors"
default[:rackspace_apt][:config][:acng][:'Remap-epel'][:value] = "file:epel_mirrors" 
default[:rackspace_apt][:config][:acng][:'Remap-slrep'][:value] = "file:sl_mirrors"
default[:rackspace_apt][:config][:acng][:ReportPage][:value] = "acng-report.html"
default[:rackspace_apt][:config][:acng][:ExTreshold][:value] = "4"
default[:rackspace_apt][:config][:acng][:ExTreshold][:comment] = "haha - this is a comment!"
default[:rackspace_apt][:config][:'01proxy']['cache_bypass'] = {}
default[:rackspace_apt][:config][:key_proxy] = ''
default[:rackspace_apt][:switch][:'cacher-client'][:restrict_environment] = false
default[:rackspace_apt][:switch][:cacher_interface] = nil
default[:rackspace_apt][:switch][:caching_server] = false
default[:rackspace_apt][:switch][:compiletime] = false
