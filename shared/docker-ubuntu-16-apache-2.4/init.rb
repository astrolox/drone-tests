require 'rspec'
require 'serverspec'

RSpec.shared_examples "docker-ubuntu-16-apache-2.4" do

  describe "Container" do
    before(:all)  do
      @container = Docker::Container.create(
        'Image'       => @image.id,
        'HostConfig'  => {
        'PortBindings' => { "#{LISTEN_PORT}/tcp" => [{ 'HostPort' => "#{LISTEN_PORT}" }]}
        }
      )
      @container.start
    end

    describe command("curl -sS http://localhost:#{LISTEN_PORT}") do
      its(:stdout) { should eq "Hello World" }
      its(:stderr) { should eq "" }
    end

    after(:all) do
      @container.kill
      @container.delete(:force => true)
    end
  end

end


