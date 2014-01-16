name              "rackspace_apt"
maintainer        "Rackspace, US Inc."
maintainer_email  "rackspace-cookbooks@rackspace.com"
license           "Apache 2.0"
description       "Configures apt and apt services and LWRPs for managing apt repositories and preferences"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "3.0.0"
recipe            "rackspace_apt", "Runs apt-get update during compile phase and sets up preseed directories"
recipe            "rackspace_apt::cacher-ng", "Set up an apt-cacher-ng caching proxy"
recipe            "rackspace_apt::cacher-client", "Client for the rackspace_apt::cacher-ng caching proxy"

%w{ ubuntu debian }.each do |os|
  supports os
end

attribute "rackspace_apt/switch/cacher_client/restrict_environment",
  :description => "Whether to restrict the search for the caching server to the same environment as this node",
  :default => "false"

attribute "rackspace_apt/config/cacher_server/Port/value",
  :description => "Default listen port for the caching server",
  :default => "3142"

attribute "rackspace_apt/switch/cacher_server/cacher_interface",
  :description => "Default listen interface for the caching server",
  :default => nil

attribute "rackspace_apt/config/key_proxy",
  :description => "Passed as the proxy passed to GPG for the apt_repository resource",
  :default => ""

attribute "rackspace_apt/switch/caching_server",
  :description => "Set this to true if the node is a caching server",
  :default => "false"
