require 'rspec'
require 'serverspec'

RSpec.shared_examples "php-5.6-tests" do

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

  describe command("curl -sS -H \"X-Forwarded-For: 99.99.99.99\" -H \"X-Forwarded-Port: 99\" http://localhost:#{LISTEN_PORT}/phpinfo.php | grep \"REMOTE_ADDR\"") do
    its(:stdout) { should contain "99.99.99.99" }
    its(:stderr) { shold eq "" }
  end

  describe command("curl -sS -H \"X-Forwarded-For: 99.99.99.99\" -H \"X-Forwarded-Port: 99\" http://localhost:#{LISTEN_PORT}/phpinfo.php | grep \"SERVER_PORT\"") do
    its(:stdout) { should contain "99" }
    its(:stderr) { should eq "" }
  end

end
