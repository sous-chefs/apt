name              'rackspace_apt'
maintainer        'Rackspace, US Inc.'
maintainer_email  'rackspace-cookbooks@rackspace.com'
license           'Apache 2.0'
description       'Configures apt and apt services and LWRPs for managing apt repositories and preferences'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '3.0.0'
recipe            'rackspace_apt', 'Runs apt-get update during compile phase and sets up preseed directories'
recipe            'rackspace_apt::cacher-ng', 'Set up an apt-cacher-ng caching proxy'
recipe            'rackspace_apt::cacher-client', 'Client for the rackspace_apt::cacher-ng caching proxy'

%w{ ubuntu debian }.each do |os|
  supports os
end
