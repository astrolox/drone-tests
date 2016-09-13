require 'rspec'
require 'serverspec'

RSpec.shared_examples "python-3-tests" do

  describe command('id -u') do
    its(:stdout) { should match /^100000$/ }
  end
  
  describe command("python --version") do
    its(:stdout) { should contain  "Python 3" }
    its(:stderr) { should eq "" }
  end
    
  describe command("which python") do
    its(:stdout) { should contain  "/var/www/._venv/bin/python" }
    its(:stderr) { should eq "" }
  end
    
  describe command("which pip") do
    its(:stdout) { should contain  "/var/www/._venv/bin/pip" }
    its(:stderr) { should eq "" }
  end

end
