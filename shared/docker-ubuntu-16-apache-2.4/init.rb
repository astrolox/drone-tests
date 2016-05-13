require 'rspec'
require 'serverspec'

RSpec.shared_examples "docker-ubuntu-16-apache-2.4" do

  describe package('apache2') do
    it { should be_installed }
  end

  describe process('httpd') do
    it { should be_running }
  end

  describe file('/etc/apache21/ports2.conf') do
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

  
  describe file('/etc/apache2/mods-available/dir.conf') do
    it { should contain('DirectoryIndex index.php index.html index.cgi index.pl index.php index.xhtml index.htm') }
  end

  describe file('/etc/apache2/sites-available/000-default.conf') do
    it { should exist }
    it { should contain('VirtualHost *:8080') }
    it { should contain('AllowOverride All') }
  end

  describe "Container" do
    before(:all)  do
      @container = Docker::Container.create(
        'Image'       => @image.id,
        'HostConfig'  => {
        'PortBindings' => { "#{LISTEN_PORT}/tcp" => [{ 'HostPort' => "#{LISTEN_PORT}" }]}
        }
      )
      @container.start
    end

    describe command("curl -sS http://localhost:#{LISTEN_PORT}") do
      its(:stdout) { should eq "Apache2.4 Container\n\n" }
      its(:stderr) { should eq "" }
    end

    after(:all) do
      @container.kill
      @container.delete(:force => true)
    end
  end

end


