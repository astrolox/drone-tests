require 'rspec'
require 'serverspec'

RSpec.shared_examples "mariadb-tests" do

    describe package('mariadb-server') do
        it { should be_installed }
    end

    describe service('mysqld') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(3306) do
      it { should be_listening }
    end
end
