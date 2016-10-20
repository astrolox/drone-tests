require 'rspec'
require 'serverspec'

RSpec.shared_examples "php-7.0-tests" do

  describe command('id -u') do
    its(:stdout) { should match /^100000$/ }
  end

  cwd=Pathname.new(File.join(File.dirname(__FILE__)))
  files = Dir["#{cwd}/files/*.php"]
  short_files = files.map { |f| File.basename(f) }
  puts "Transferring files to container: #{short_files}"
  Specinfra::Runner.send_file( files, "/var/www/html/")
  short_files.each do |f|
    describe command("curl -sS http://localhost:#{LISTEN_PORT}/#{f}") do
      its(:stdout) { should eq "Success" }
      its(:stderr) { should eq "" }
    end
  end

  phpinfo = Dir["#{cwd}/phpinfo.php"]
  Specinfra::Runner.send_file( phpinfo, "/var/www/html/")

  describe command("curl -sS -H \"X-Forwarded-For: 1.2.3.4\" -H \"X-Forwarded-Port: 99\" http://127.0.0.1:#{LISTEN_PORT}/phpinfo.php | grep \"REMOTE_ADDR\"") do
    its(:stdout) { should contain "1.2.3.4" }
    its(:stderr) { should eq "" }
  end

  describe command("curl -sS -H \"X-Forwarded-For: 1.2.3.4\" -H \"X-Forwarded-Port: 99\" http://127.0.0.1:#{LISTEN_PORT}/phpinfo.php | grep \"SERVER_PORT\"") do
    its(:stdout) { should contain "99" }
    its(:stderr) { should eq "" }
  end

end
