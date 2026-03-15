# frozen_string_literal: true

provides :apt_config
unified_mode true

action_class do
  include Apt::Helpers
end

property :periodic_update_min_delay, Integer, default: 86_400
property :compile_time_update, [true, false], default: false
property :force_confask, [true, false], default: false
property :force_confdef, [true, false], default: false
property :force_confmiss, [true, false], default: false
property :force_confnew, [true, false], default: false
property :force_confold, [true, false], default: false
property :install_recommends, [true, false], default: true
property :install_suggests, [true, false], default: false

default_action :create

action :create do
  return unless apt_installed?

  if new_resource.compile_time_update
    apt_update 'compile time' do
      frequency new_resource.periodic_update_min_delay
      ignore_failure true
      action :periodic
    end
  end

  apt_update 'periodic' do
    frequency new_resource.periodic_update_min_delay
  end

  file '/var/lib/apt/periodic/update-success-stamp' do
    owner 'root'
    group 'root'
    mode '0644'
  end

  %w(/var/cache/local /var/cache/local/preseeding).each do |dirname|
    directory dirname do
      owner 'root'
      group 'root'
      mode '0755'
    end
  end

  template '/etc/apt/apt.conf.d/10dpkg-options' do
    cookbook 'apt'
    source '10dpkg-options.erb'
    variables(
      force_confask: new_resource.force_confask,
      force_confdef: new_resource.force_confdef,
      force_confmiss: new_resource.force_confmiss,
      force_confnew: new_resource.force_confnew,
      force_confold: new_resource.force_confold
    )
  end

  template '/etc/apt/apt.conf.d/10recommends' do
    cookbook 'apt'
    source '10recommends.erb'
    variables(
      install_recommends: new_resource.install_recommends,
      install_suggests: new_resource.install_suggests
    )
  end

  package %w(apt-transport-https gnupg dirmngr)
end

action :delete do
  return unless apt_installed?

  file '/var/lib/apt/periodic/update-success-stamp' do
    action :delete
  end

  %w(/etc/apt/apt.conf.d/10dpkg-options /etc/apt/apt.conf.d/10recommends).each do |path|
    file path do
      action :delete
    end
  end

  %w(/var/cache/local/preseeding /var/cache/local).each do |dirname|
    directory dirname do
      recursive true
      action :delete
    end
  end

  package %w(apt-transport-https gnupg dirmngr) do
    action :remove
  end
end
