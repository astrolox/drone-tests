require 'rspec'
require 'serverspec'

RSpec.shared_examples "customerssh" do

  describe file('/etc/lsb-release') do
    it { should contain 'DISTRIB_RELEASE=16.04' }
  end

  describe command('id -u') do
    its(:stdout) { should match /^100000$/ }
  end

  describe package('perl') do
    it {should be_installed}
  end

  describe package('git') do
    it {should be_installed}
  end

  describe package('traceroute') do
    it {should be_installed}
  end
  
  describe package('telnet') do
    it {should be_installed}
  end

  describe package('nano') do
    it {should be_installed}
  end
  
  describe package('mysql-client') do
    it {should be_installed}
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

 describe file('/hooks') do
   it { should be_directory }
   it { should be_mode 755 }
 end

 describe file('/init') do
   it { should be_directory }
   it { should be_mode 755 }
 end

 describe file('/init/entrypoint') do
   it { should exist }
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
   its(:stdout) { should match /^total 0$/ }
 end
end
