require 'rspec'
require 'serverspec'

RSpec.shared_examples "nodejs-4-tests" do

  describe command('id -u') do
    its(:stdout) { should match /^100000$/ }
  end
  
  describe command("nodejs --version") do
    its(:stdout) { should contain  "v4" }
    its(:stderr) { should eq "" }
  end

end
