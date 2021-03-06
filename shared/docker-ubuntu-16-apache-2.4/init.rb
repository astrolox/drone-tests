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
  Specinfra::Runner.run_command("mkdir /var/www/html/cgi-bin")
  # Specinfra::Runner.send_file( "#{cwd}/files/cgi-bin/.htaccess", "/var/www/html/cgi-bin/")
  Specinfra::Runner.send_file( "#{cwd}/files/test/rpaf.sh", "/var/www/html/cgi-bin/")


  describe file('/var/www/html/cgi-bin') do
    it { should exist }
    it { should be_directory }
  end

  # New drupal htaccess file breaks CGI bin. Adding removal of file.
  describe command("if [ -e '/var/www/html/.htaccess' ]; then echo 'Moving .htaccess file'; mv /var/www/html/.htaccess /var/www/html/disabled_htaccess; else echo 'No htaccess exists'; fi") do
    its(:exit_status) { should eq 0 }
  end

  describe file('/var/www/html/cgi-bin/rpaf.sh') do
    it { should exist }
    it { should be_file }
    it { should be_executable.by('others') }
  end

  describe command("curl -sS -H \"X-Forwarded-For: 1.2.3.4\" -H \"X-Forwarded-Port: 99\" http://127.0.0.1:#{LISTEN_PORT}/cgi-bin/rpaf.sh") do
    its(:stdout) { should contain('99') }
    its(:stderr) { should eq "" }
  end

  describe command("grep \"1.2.3.4\" /var/log/apache2/*.log") do
    its(:stdout) { should contain('1.2.3.4') }
    its(:stdout) { should contain('curl') }
    its(:stderr) { should eq "" }
  end

  # Now add htaccess back for any CMS work required
  describe command("if [ -e '/var/www/html/disabled_htaccess' ]; then echo 'Moving disabled .htaccess file back'; mv /var/www/html/disabled_htaccess /var/www/html/.htaccess; else echo 'No disabled htaccess exists'; fi") do
    its(:exit_status) { should eq 0 }
  end

end
