require 'rspec'
require 'serverspec'

RSpec.shared_examples "docker-ubuntu-16-nginx-1.10.0-passenger" do

  describe file('/etc/nginx/sites-enabled/default') do
    it { should contain('listen 8080') }
    it { should contain('listen [::]:8080') }
  end

  describe file('/etc/nginx/nginx.conf') do
    it { should exist }
    it { should contain('daemon off;') }
  end

  describe file('/var/log/nginx') do
      it { should exist }
      it { should be_directory }
      it { should be_mode 777 }
  end

  describe file('/var/lib/nginx') do
      it { should exist }
      it { should be_directory }
      it { should be_mode 777 }
  end
  
  describe package('nginx-common') do
    it { should be_installed }
  end

  describe process('nginx') do
    it { should be_running }
  end

  describe file('/var/run/nginx.pid') do
    it { should exist }
    it { should be_file }
  end
  
  cwd=Pathname.new(File.join(File.dirname(__FILE__)))
  testfile = Dir["#{cwd}/files/test.html"]
  short_files = testfile.map { |f| File.basename(f) }
  puts "Transferring files to container: #{short_files}"
#  set :backend, :docker
#  set :docker_container, @container.id
  Specinfra::Runner.run_command("mkdir -p /var/www/public")
  Specinfra::Runner.send_file( testfile, "/var/www/public")
  short_files.each do |f|
    describe command("curl -sS http://localhost:#{LISTEN_PORT}/#{f}") do
      its(:stdout) { should eq "Nginx\n" }
      its(:stderr) { should eq "" }
    end
  end

end
