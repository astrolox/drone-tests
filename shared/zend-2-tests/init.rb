require 'rspec'
require 'serverspec'

RSpec.shared_examples "zend-2-tests" do

    describe command("curl -sS http://localhost:#{LISTEN_PORT}/index.php") do
      its(:stdout) { should contain  "ZF2 Skeleton Application" }
      its(:stderr) { should eq "" }
    end

end
