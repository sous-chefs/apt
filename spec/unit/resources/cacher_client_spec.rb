# frozen_string_literal: true

require 'spec_helper'

describe 'apt_cacher_client' do
  step_into :apt_cacher_client
  platform 'ubuntu', '22.04'

  context 'without a cache server' do
    before do
      stub_command('grep Acquire::http::Proxy /etc/apt/apt.conf').and_return(false)
    end

    recipe do
      apt_cacher_client 'default'
    end

    it { is_expected.to delete_file('/etc/apt/apt.conf.d/01proxy') }
  end

  context 'with a cache server' do
    before do
      stub_command('grep Acquire::http::Proxy /etc/apt/apt.conf').and_return(false)
    end

    recipe do
      apt_cacher_client 'default' do
        cacher_server(
          host: 'localhost',
          port: 9876,
          proxy_ssl: true
        )
      end
    end

    it { is_expected.to render_file('/etc/apt/apt.conf.d/01proxy').with_content('Acquire::http::Proxy "http://localhost:9876";') }
    it { is_expected.to render_file('/etc/apt/apt.conf.d/01proxy').with_content('Acquire::https::Proxy "http://localhost:9876";') }
    it 'refreshes apt metadata when the proxy changes' do
      expect(chef_run.template('/etc/apt/apt.conf.d/01proxy')).to notify('apt_update[update for proxy change]').to(:update).immediately
    end
  end
end
