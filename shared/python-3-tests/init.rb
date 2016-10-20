require 'rspec'
require 'serverspec'

RSpec.shared_examples "python-3-tests" do

  describe command('id -u') do
    its(:stdout) { should match /^100000$/ }
  end

end
