name 'apt'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Configures apt and apt caching.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '7.0.0'

recipe 'apt::default', 'Runs apt-get update during compile phase and sets up preseed directories'
recipe 'apt::cacher-ng', 'Set up an apt-cacher-ng caching proxy'
recipe 'apt::cacher-client', 'Client for the apt::cacher-ng caching proxy'

%w(ubuntu debian).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/apt'
issues_url 'https://github.com/chef-cookbooks/apt/issues'
chef_version '>= 13.3' if respond_to?(:chef_version)
