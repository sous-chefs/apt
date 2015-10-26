name 'apt'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Configures apt and apt services. Ships resources for managing apt repositories'
issues_url 'https://github.com/chef-cookbooks/apt/issues' if respond_to?(:issues_url)
source_url 'https://github.com/chef-cookbooks/apt' if respond_to?(:source_url)
version '2.9.2'

recipe 'apt::default', 'Runs apt-get update during compile phase and sets up preseed directories'
recipe 'apt::cacher-ng', 'Set up an apt-cacher-ng caching proxy'
recipe 'apt::cacher-client', 'Client for the apt::cacher-ng caching proxy'

%w(ubuntu debian).each do |os|
  supports os
end
