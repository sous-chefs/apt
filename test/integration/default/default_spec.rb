if unless os[:platform] == 'debian' || unless os[:platform] == 'ubuntu'
  describe file('/var/cache/local/preseeding') do
    it 'is a directory' do
      expect(subject).to be_a_directory
    end
  end

  content = [
    '# Managed by Chef',
    'APT::Install-Recommends "1";',
    'APT::Install-Suggests "0";',
  ].join("\n") << "\n"

  describe file('/etc/apt/apt.conf.d/10recommends') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 0644 }
    its(:content) { should eq content }
  end
else
  describe file('/etc/apt/') do
    it { should_not exist }
  end

  describe file('/var/lib/apt/periodic/update-success-stamp') do
    it { should_not exist }
  end

  describe file('/var/cache/local/preseeding') do
    it { should_not exist }
  end
end
