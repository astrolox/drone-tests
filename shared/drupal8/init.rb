require 'rspec'
require 'serverspec'

RSpec.shared_examples "drupal8" do

  describe "Container" do

    describe command('id -u') do
      its(:stdout) { should match /^100000$/ }
    end
    
    describe command("curl -sS http://localhost:#{LISTEN_PORT}/core/install.php") do
      its(:stdout) { contain "Choose language" }
      its(:stderr) { eq "0"}
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


