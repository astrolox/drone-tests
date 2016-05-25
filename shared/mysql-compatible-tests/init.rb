require 'rspec'
require 'serverspec'

RSpec.shared_examples "mysql-compatible-tests" do

    describe package(PACKAGE_NAME) do
        it { should be_installed }
    end

    describe service('mysql') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(3306) do
      it { should be_listening }
    end

    describe group('mysql') do
        it { should exist }
    end

    describe user('mysql') do
        it { should exist }
        it { should belong_to_group 'mysql' }
    end

    describe "create database" do
        describe command("echo \"DROP DATABASE IF EXISTS dbtest; CREATE DATABASE dbtest; SHOW DATABASES LIKE 'dbtest'\" | mysql -h localhost --user=root --password=$MYSQL_ROOT_PASSWORD") do
            its(:stdout) { should match /dbtest/ }
            its(:stderr) { should eq "mysql: [Warning] Using a password on the command line interface can be insecure.\n" }
        end
    end

    describe "create user and run query" do
        describe command("echo \"CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'testpass'; GRANT ALL PRIVILEGES ON *.* TO 'testuser'@'localhost'; FLUSH PRIVILEGES; SELECT user, host FROM mysql.user WHERE user='testuser' AND host='localhost' \" | mysql --user=root --password=$MYSQL_ROOT_PASSWORD") do
            #its(:stdout) { should match /testuser\tlocalhost/ }
            #its(:stderr) { should eq "" }
        end
    end

    describe "check pma user exists" do
        describe command("echo \"SELECT user FROM mysql.user WHERE user='pma'\" | mysql --user=root --password=$MYSQL_ROOT_PASSWORD") do
            #its(:stdout) { should match /pma/ }
            #its(:stderr) { should eq "" }
        end
    end
end
