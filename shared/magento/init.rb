require 'rspec'
require 'serverspec'

RSpec.shared_examples "magento" do

  describe "Container" do

    describe command('id -u') do
      its(:stdout) { should match /^100000$/ }
    end
    
    describe file('/var/www/html/composer.json') do
    it { should exist }
    it { should be_file }
    it { should contain('"version": "2.0.7"') }
  end

    describe command("curl -sS http://localhost:#{LISTEN_PORT}/setup/#/landing-install") do
      its(:stdout) { should contain "magentoSetup" }
      its(:stderr) { should eq ""}
    end
#    cwd=Pathname.new(File.join(File.dirname(__FILE__)))
#    files = Dir["#{cwd}/files/*.php"]
#    short_files = files.map { |f| File.basename(f) }
#    Specinfra::Runner.send_file( files, "/var/www/html/")
#    short_files.each do |f|
#      describe command("curl -sS http://localhost:#{LISTEN_PORT}/#{f}") do
#        its(:stdout) { should eq "Success" }
#        its(:stderr) { should eq "" }
#      end
#    end

  end

end
