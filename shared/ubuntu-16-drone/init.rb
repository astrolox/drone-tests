require 'rspec'
require 'serverspec'

RSpec.shared_examples "ubuntu-16-drone" do
  
  describe file('/etc/lsb-release') do
    it { should contain 'DISTRIB_RELEASE=16.04' }
  end

  describe file('/opt/drone') do
    it { should be_directory }
  end

end
