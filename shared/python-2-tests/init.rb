require 'rspec'
require 'serverspec'

RSpec.shared_examples "python-2-tests" do

  describe command('id -u') do
    its(:stdout) { should match /^100000$/ }
  end
  
  describe command("python --version") do
    its(:stdout) { should contain  "Python 2" }
    its(:stderr) { should eq "" }
  end

end
