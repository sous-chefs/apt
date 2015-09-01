require_relative './spec_helper'

describe 'apt::default' do
  describe file('/var/cache/local/preseeding') do
    it 'is a directory' do
      expect(subject).to be_a_directory
    end
  end

  content = [
    '# Managed by Chef',
    'APT::Install-Recommends "1";',
    'APT::Install-Suggests "0";'
  ].join("\n") << "\n"

  describe file('/etc/apt/apt.conf.d/10recommends') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should eq content }
  end
end
