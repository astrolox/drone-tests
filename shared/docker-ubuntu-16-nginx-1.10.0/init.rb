require 'rspec'
require 'serverspec'

RSpec.shared_examples "docker-ubuntu-16-nginx-1.10.0" do

  describe package('nginx') do
    it { should be_installed }
  end

    describe process('nginx') do
    it { should be_running }
  end

  describe file('/etc/nginx/sites-available/default') do
    it { should contain('listen 8080') }
    it { should contain('listen [::]:8080') }
  end

    describe file('/var/run/nginx.pid') do
        it { should exist }
        it { should be_file }
    end

    describe file('/etc/nginx/nginx.conf') do
        it { should exist }
        it { should contain('daemon off;') }
    end

    describe file('/var/log/nginx') do
        it { should exist }
        it { should be_directory }
        it { should be_writable.by('group') }
        it { should be_readable.by('others') }
        it { should be_writable.by('others') }
        it { should be_executable.by('others') }
    end

    describe file('/var/lib/nginx') do
        it { should exist }
        it { should be_directory }
        it { should be_writable.by('group') }
        it { should be_writable.by('others') }
    end

  describe "Container tests" do
    @container = Docker::Container.create(
      'Image'       => Docker::Image.get(ENV['IMAGE']).id,
      'HostConfig'  => {
      'PortBindings' => { "#{LISTEN_PORT}/tcp" => [{ 'HostPort' => "#{LISTEN_PORT}" }]}
      }
    )
    @container.start

    describe command("curl -sS http://localhost:#{LISTEN_PORT}") do
      its(:stdout) { should eq "Nginx\n" }
      its(:stderr) { should eq "" }
    end

    @container.kill
    @container.delete(:force => true)
  end


end
