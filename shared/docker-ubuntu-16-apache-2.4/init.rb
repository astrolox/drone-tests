require 'rspec'
require 'serverspec'

RSpec.shared_examples "docker-ubuntu-16-apache-2.4" do

  describe package('apache2') do
    it { should be_installed }
  end

    describe process('apache2') do
    it { should be_running }
  end

  describe file('/etc/apache2/ports.conf') do
    it { should contain('Listen 8080') }
  end

  describe file('/var/lock/apache2') do
    it { should exist }
    it { should be_directory }
    it { should be_writable.by('others') }
  end

  describe file('/var/run/apache2') do
    it { should exist }
    it { should be_directory }
    it { should be_writable.by('others') }
  end

  describe file('/etc/apache2/mods-enabled/rewrite.load') do
    it { should exist }
    it { should be_file }
  end

  describe file('/etc/apache2/sites-available/000-default.conf') do
    it { should exist }
    it { should contain('VirtualHost *:8080') }
    it { should contain('AllowOverride All') }
  end

  cwd=Pathname.new(File.join(File.dirname(__FILE__)))
  files = Dir["#{cwd}/files/*.html"]
  short_files = files.map { |f| File.basename(f) }
  Specinfra::Runner.send_file( files, "/var/www/html/")
  short_files.each do |f|
    describe command("curl -sS http://localhost:#{LISTEN_PORT}/#{f}") do
      its(:stdout) { should contain "Success" }
      its(:stderr) { should eq "" }
    end
  end

  cwd=Pathname.new(File.join(File.dirname(__FILE__)))
  Specinfra::Runner.send_directory("#{cwd}/files/test", "/var/www/html/test")

  describe file('/var/www/html/test') do
    it { should exist }
    it { should be_directory }
  end

  describe file('/var/www/html/test/rpaf.sh') do
    it { should exist }
    it { should be_file }
    it { should be_executable.by('others') }
  end

  describe command("curl -sS -H \"X-Forwarded-For: 1.2.3.4\" -H \"X-Forwarded-Port: 99\" http://localhost:#{LISTEN_PORT}/test/rpaf.sh") do
    its(:stdout) { should contain('1.2.3.4') }
    its(:stdout) { should contain('99') }
    its(:stderr) { should eq "" }
  end

end
