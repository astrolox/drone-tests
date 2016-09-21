require 'rspec'
require 'serverspec'

RSpec.shared_examples "python-2-tests" do

  describe command('id -u') do
    its(:stdout) { should match /^100000$/ }
  end

  describe command("python --version") do
    its(:stdout) { should contain  "" }
    its(:stderr) { should contain  "Python 2" }
  end
<<<<<<< 08fba85aaabbfbe3537ae3e2e2dc5fd651a52b9b

  describe command("which python") do
    its(:stdout) { should contain  "/var/www/._venv/bin/python" }
    its(:stderr) { should eq "" }
  end

  describe command("which pip") do
    its(:stdout) { should contain  "/var/www/._venv/bin/pip" }
    its(:stderr) { should eq "" }
  end
=======
>>>>>>> Removed rspec test that expects virtual env to exist already. This wont happen any more because the environment gets setup when the pod runs for the first time.

end
