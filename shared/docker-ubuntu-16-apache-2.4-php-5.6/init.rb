require 'rspec'
require 'serverspec'

RSpec.shared_examples "docker-ubuntu-16-apache-2.4-php-5.6" do

  describe "Container" do
    @container = Docker::Container.create(
      'Image'        => Docker::Image.get(ENV['IMAGE']).id,
      'HostConfig'   => {
      'PortBindings' => { "#{LISTEN_PORT}/tcp" => [{ 'HostPort' => "#{LISTEN_PORT}" }]}
      }
    )
    @container.start

    describe command("echo '<?php echo phpversion(); ?>' > /var/www/html/rspecphpversion.php") do
      its(:exit_status) { should eq 0 }
    end

    describe command('id -u') do
      its(:stdout) { should match /^100000$/ }
    end

    describe command("curl -sS http://localhost:#{LISTEN_PORT}/rspecphpversion.php") do
      its(:stdout) { should start_with "5.6." }
      its(:stderr) { should eq "" }
    end

    @container.kill
    @container.delete(:force => true)
  end

end


