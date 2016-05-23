require 'rspec'
require 'serverspec'

RSpec.shared_examples "phpmyadmin-4.6-tests" do

    describe command("curl -sS http://localhost:#{LISTEN_PORT}") do
        its(:stdout) { should contain "phpMyAdmin" }
        its(:stderr) { should eq "" }
    end

    describe command("echo $PHP_UPLOAD_MAX_FILESIZE") do
        its(:stdout) { should eq "64M\n"}
        its(:stderr) { should eq "" }
    end

    describe command("echo $PMA_CONTROL_HOST") do
        its(:stdout) { should eq "localhost\n"}
        its(:stderr) { should eq "" }
    end

    describe command("echo $PMA_CONTROL_PORT") do
        its(:stdout) { should eq "3306\n"}
        its(:stderr) { should eq "" }
    end

    describe file('/hooks/supervisord-pre.d/40_phpmyadmin_config_secret') do
        it { should exist }
        it { should be_file }
    end
end
