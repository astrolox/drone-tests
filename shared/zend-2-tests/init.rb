require 'rspec'
require 'serverspec'

RSpec.shared_examples "zend-2-tests" do

    describe command("curl -sS http://localhost:#{LISTEN_PORT}/") do
      its(:stdout) { should contain  "ZF2 Skeleton Application" }
      its(:stdout) { should contain  "Zend Framework version 2.3.3" }
      its(:stderr) { should eq "" }
    end

end
