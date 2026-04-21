# frozen_string_literal: true

provides :apt_cacher_client
unified_mode true

property :cacher_server, Hash, default: {}

default_action :create

action_class do
  def normalized_cacher_server
    new_resource.cacher_server.each_with_object({}) do |(key, value), acc|
      acc[key.to_s] = value.is_a?(Hash) ? value.transform_keys(&:to_s) : value
    end
  end
end

action :create do
  apt_update 'update for proxy change' do
    action :nothing
  end

  execute 'remove legacy proxy from /etc/apt/apt.conf' do
    command "sed --in-place '/^Acquire::http::Proxy/d' /etc/apt/apt.conf"
    only_if 'grep Acquire::http::Proxy /etc/apt/apt.conf'
  end

  if normalized_cacher_server.empty?
    file '/etc/apt/apt.conf.d/01proxy' do
      action :delete
    end
  else
    template '/etc/apt/apt.conf.d/01proxy' do
      cookbook 'apt'
      source '01proxy.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(cacher_server: normalized_cacher_server)
      notifies :update, 'apt_update[update for proxy change]', :immediately
    end
  end
end

action :delete do
  file '/etc/apt/apt.conf.d/01proxy' do
    action :delete
  end
end
