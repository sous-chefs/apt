require 'spec_helper'

describe 'apt::cacher-client' do
  platform 'ubuntu'

  context 'no server' do
    before do
      stub_command('grep Acquire::http::Proxy /etc/apt/apt.conf').and_return(false)
    end

    it 'does not create 01proxy file' do
      expect(chef_run).not_to create_file('/etc/apt/apt.conf.d/01proxy')
    end
  end

  context 'server provided' do
    override_attributes['apt']['cacher_client']['cacher_server'] = {
      host: 'localhost',
      port: 9876,
      proxy_ssl: true,
    }

    before do
      stub_command('grep Acquire::http::Proxy /etc/apt/apt.conf').and_return(false)
    end

    it 'creates 01proxy file' do
      expect(chef_run).to render_file('/etc/apt/apt.conf.d/01proxy').with_content(
        'Acquire::http::Proxy "http://localhost:9876";'
      )
    end
  end
end
