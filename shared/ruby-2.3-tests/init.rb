require 'rspec'
require 'serverspec'

RSpec.shared_examples "ruby-2.3-tests" do

  describe command('id -u') do
    its(:stdout) { should match /^100000$/ }
  end

  describe command("ruby --version") do
    its(:stdout) { should contain  "ruby 2.3" }
    its(:stderr) { should eq "" }
  end

  describe command("echo $GEM_HOME") do
    its(:stdout) { should eq  "/var/www/._gems\n" }
    its(:stderr) { should eq "" }
  end

end
