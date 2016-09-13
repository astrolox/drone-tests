require 'rspec'
require 'serverspec'

RSpec.shared_examples "passenger-5-tests" do

    describe command("passenger --version") do
      its(:stdout) { should contain  "Phusion Passenger 5" }
      its(:stderr) { should eq "" }
    end

end
