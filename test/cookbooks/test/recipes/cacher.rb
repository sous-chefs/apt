# frozen_string_literal: true

apt_config 'default'

apt_cacher_ng 'default' do
  cacher_dir '/tmp/apt-cacher'
  cacher_port 9876
  cacher_interface '0.0.0.0'
end

apt_cacher_client 'default' do
  cacher_server(
    host: 'localhost',
    port: 9876,
    proxy_ssl: true,
    cache_bypass: {
      'download.oracle.com' => 'https',
      'nginx.org' => 'https',
    }
  )
end

package 'colordiff'
