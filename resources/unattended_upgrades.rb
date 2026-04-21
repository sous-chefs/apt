# frozen_string_literal: true

provides :apt_unattended_upgrades
unified_mode true

include Apt::Helpers

property :enable, [true, false], default: false
property :update_package_lists, [true, false], default: true
property :allowed_origins, Array, default: lazy { ["#{node['platform'].capitalize} #{apt_codename}"] }
property :origins_patterns, Array, default: []
property :package_blacklist, Array, default: []
property :auto_fix_interrupted_dpkg, [true, false], default: false
property :minimal_steps, [true, false], default: false
property :install_on_shutdown, [true, false], default: false
property :mail, [String, nil]
property :sender, [String, nil]
property :mail_only_on_error, [true, false], default: true
property :remove_unused_dependencies, [true, false], default: false
property :automatic_reboot, [true, false], default: false
property :automatic_reboot_time, String, default: 'now'
property :dl_limit, [Integer, String, nil], default: nil
property :random_sleep, [Integer, String, nil], default: nil
property :syslog_enable, [true, false], default: false
property :syslog_facility, String, default: 'daemon'
property :only_on_ac_power, [true, false], default: true
property :dpkg_options, Array, default: []

default_action :create

action :create do
  directory '/var/cache/local/preseeding' do
    owner 'root'
    group 'root'
    mode '0755'
  end

  template '/var/cache/local/preseeding/unattended-upgrades.seed' do
    cookbook 'apt'
    source 'unattended-upgrades.seed.erb'
    owner 'root'
    group 'root'
    mode '0600'
    variables(enable: new_resource.enable)
    sensitive true
    notifies :run, 'execute[preseed unattended-upgrades]', :immediately
  end

  execute 'preseed unattended-upgrades' do
    command 'debconf-set-selections /var/cache/local/preseeding/unattended-upgrades.seed'
    sensitive true
    action :nothing
  end

  package 'unattended-upgrades' do
    action :install
  end

  package 'bsd-mailx' do
    action :install
    not_if { new_resource.mail.nil? }
  end

  template '/etc/apt/apt.conf.d/20auto-upgrades' do
    cookbook 'apt'
    source '20auto-upgrades.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      update_package_lists: new_resource.update_package_lists,
      enable: new_resource.enable,
      random_sleep: new_resource.random_sleep
    )
  end

  template '/etc/apt/apt.conf.d/50unattended-upgrades' do
    cookbook 'apt'
    source '50unattended-upgrades.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      allowed_origins: new_resource.allowed_origins,
      origins_patterns: new_resource.origins_patterns,
      package_blacklist: new_resource.package_blacklist,
      auto_fix_interrupted_dpkg: new_resource.auto_fix_interrupted_dpkg,
      minimal_steps: new_resource.minimal_steps,
      install_on_shutdown: new_resource.install_on_shutdown,
      mail: new_resource.mail,
      sender: new_resource.sender,
      mail_only_on_error: new_resource.mail_only_on_error,
      remove_unused_dependencies: new_resource.remove_unused_dependencies,
      automatic_reboot: new_resource.automatic_reboot,
      automatic_reboot_time: new_resource.automatic_reboot_time,
      dl_limit: new_resource.dl_limit,
      syslog_enable: new_resource.syslog_enable,
      syslog_facility: new_resource.syslog_facility,
      dpkg_options: new_resource.dpkg_options,
      only_on_ac_power: new_resource.only_on_ac_power
    )
  end
end

action :delete do
  %w(/etc/apt/apt.conf.d/20auto-upgrades /etc/apt/apt.conf.d/50unattended-upgrades).each do |path|
    file path do
      action :delete
    end
  end

  file '/var/cache/local/preseeding/unattended-upgrades.seed' do
    action :delete
  end

  package %w(unattended-upgrades bsd-mailx) do
    action :remove
  end
end
