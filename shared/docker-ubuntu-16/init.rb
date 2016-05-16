require 'rspec'
require 'serverspec'

RSpec.shared_examples "docker-ubuntu-16" do

  describe file('/etc/lsb-release') do
    it { should contain 'DISTRIB_RELEASE=16.04' }
  end

  describe command('id -u') do
    its(:stdout) { should eq '100000\n' }
  end

  describe package('supervisor') do
    it { should be_installed }
  end

  describe package('vim') do
    it { should be_installed }
  end

  describe package('curl') do
    it { should be_installed }
  end

 describe package('bzip2') do
   it { should be_installed }
 end

 describe process('supervisord') do
   it { should be_running }
 end

 describe file('/hooks') do
   it { should be_directory }
   it { should be_writable.by('others') }
 end

 describe file('/init') do
   it { should be_directory }
   it { should be_writable.by('others') }
 end

 describe file('/var/log/supervisor') do
   it { should be_directory }
   it { should be_writable.by('others') }
 end

 describe file('/init/entrypoint') do
   it { should exist }
 end

 describe file ('/etc/supervisor/supervisord.conf') do
   it { should exist }
   it { should contain('command=/etc/supervisor/exit_on_fatal.py') }
 end

 describe file ('/var/run') do
   it { should exist }
   it { should be_writable.by('others') }
 end

 describe file ('/tmp/sockets') do
   it { should exist }
   it { should be_writable.by('others') }
 end

 describe command('ls -l /var/lib/apt/lists') do
   its(:stdout) { should match '0' }
 end

end


