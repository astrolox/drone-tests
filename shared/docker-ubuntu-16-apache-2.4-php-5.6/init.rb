require 'rspec'
require 'serverspec'

RSpec.shared_examples "docker-ubuntu-16-apache-2.4-php-5.6" do

  describe "Container" do
    before(:all)  do
      @container = Docker::Container.create(
        'Image'        => @image.id,
        'HostConfig'   => {
        'PortBindings' => { "#{LISTEN_PORT}/tcp" => [{ 'HostPort' => "#{LISTEN_PORT}" }]}
        }
      )
      @container.start
    end

    describe command("echo '<?php phpinfo(); ?>' > /var/www/html/rspecphpinfo.php") do
      its(:exit_status) { should eq 0 }
    end

    describe command("curl -sS http://localhost:#{LISTEN_PORT}/rspecphpinfo.php") do
      its(:stdout) { should match (/PHP Version 5\.6\.21\-7\+donate\.sury\.org~xenial\+1/) }
      its(:stderr) { should eq "" }
    end

    after(:all) do
      @container.kill
      @container.delete(:force => true)
    end
  end

end


