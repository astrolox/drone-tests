require 'rspec'
require 'serverspec'

RSpec.shared_examples "wordpress" do

  describe "Container" do

    describe command('id -u') do
      its(:stdout) { should match /^100000$/ }
    end

    describe command("curl -sS http://localhost:#{LISTEN_PORT}/wp-admin/setup-config.php") do
      its(:stdout) { should contain  "Select a default language" }
      its(:stderr) { should eq "" }
    end

#    describe command("curl -d weblog_title='testing.com' -d user_name='bob' -d admin_password='IAmAPassword1' -d admin_password2='IAmAPassword1' -d pw_weak='on' -d admin_email='123@123.com' -d blog_public='1' -d Submit='Install WordPress' -L http://localhost:#{LISTEN_PORT}/wp-admin/install.php?step=2") 
#      its(:stdout) { should contain "Success" }
#      its(:stderr) { should eq "" }
#    end
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


