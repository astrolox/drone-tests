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

    describe command('id -u') do
      its(:stdout) { should match /^100000$/ }
    end

    cwd=Pathname.new(File.join(File.dirname(__FILE__)))
    files = Dir["#{cwd}/files/*.php"]
    short_files = files.map { |f| File.basename(f) }
    Specinfra::Runner.send_file( files, "/var/www/html/")
    short_files.each do |f|
      describe command("curl -sS http://localhost:#{LISTEN_PORT}/#{f}") do
        its(:stdout) { should eq "Success" }
        its(:stderr) { should eq "" }
      end
    end

    @container.kill
    @container.delete(:force => true)
  end

end


