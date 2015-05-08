#
# Cookbook Name:: apt
# Attributes:: default
#
# Copyright 2009-2013, Chef Software, Inc.
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

default['apt']['cacher-client']['restrict_environment'] = false
default['apt']['cacher_dir'] = '/var/cache/apt-cacher-ng'
default['apt']['cacher_interface'] = nil
default['apt']['cacher_port'] = 3142
default['apt']['cacher_ssl_support'] = false
default['apt']['caching_server'] = false
default['apt']['compiletime'] = false
default['apt']['compile_time_update'] = false
default['apt']['key_proxy'] = ''
default['apt']['cache_bypass'] = {}
default['apt']['periodic_update_min_delay'] = 86_400
default['apt']['launchpad_api_version'] = '1.0'
default['apt']['unattended_upgrades']['enable'] = false
default['apt']['unattended_upgrades']['update_package_lists'] = true
# this needs a good default
codename = node.attribute?('lsb') ? node['lsb']['codename'] : 'notlinux'
default['apt']['unattended_upgrades']['allowed_origins'] = [
  "#{node['platform'].capitalize} #{codename}"
]
default['apt']['unattended_upgrades']['package_blacklist'] = []
default['apt']['unattended_upgrades']['auto_fix_interrupted_dpkg'] = false
default['apt']['unattended_upgrades']['minimal_steps'] = false
default['apt']['unattended_upgrades']['install_on_shutdown'] = false
default['apt']['unattended_upgrades']['mail'] = nil
default['apt']['unattended_upgrades']['mail_only_on_error'] = true
default['apt']['unattended_upgrades']['remove_unused_dependencies'] = false
default['apt']['unattended_upgrades']['automatic_reboot'] = false
default['apt']['unattended_upgrades']['automatic_reboot_time'] = 'now'
default['apt']['unattended_upgrades']['dl_limit'] = nil

default['apt']['sources_list']['include_source_packages'] = true
default['apt']['sources_list']['enable_cdn'] = false

default['apt']['sources_list']['ubuntu']['cdn_url'] = 'mirror://mirrors.ubuntu.com/mirrors.txt'
default['apt']['sources_list']['ubuntu']['archive_url']  = 'http://us.archive.ubuntu.com/ubuntu'
default['apt']['sources_list']['ubuntu']['security_url'] = 'http://security.ubuntu.com/ubuntu'
default['apt']['sources_list']['ubuntu']['partners_url'] = 'http://archive.canonical.com/ubuntu'
default['apt']['sources_list']['ubuntu']['components'] = 'main restricted universe multiverse'
default['apt']['sources_list']['ubuntu']['enable_updates'] = true
default['apt']['sources_list']['ubuntu']['enable_backports'] = true
default['apt']['sources_list']['ubuntu']['enable_partners'] = false

default['apt']['sources_list']['debian']['cdn_url']  = 'http://httpredir.debian.org/debian'
default['apt']['sources_list']['debian']['archive_url']  = 'http://mirrors.kernel.org/debian'
default['apt']['sources_list']['debian']['security_url'] = 'http://security.debian.org/'
default['apt']['sources_list']['debian']['components'] = 'main contrib non-free'
default['apt']['sources_list']['debian']['enable_updates'] = true
default['apt']['sources_list']['debian']['enable_backports'] = false
