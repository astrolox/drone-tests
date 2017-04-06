require 'rspec'
require 'serverspec'

RSpec.shared_examples "mysql-tests" do

    describe package('mysql-server') do
        it { should be_installed }
    end

    describe process('mysqld') do
      it { should be_running }
    end

#    describe group('mysql') do
#        it { should exist }
#    end

#    describe user('mysql') do
#        it { should exist }
#        it { should belong_to_group 'mysql' }
#    end

    describe "create database" do
        describe command("echo \"DROP DATABASE IF EXISTS dbtest; CREATE DATABASE dbtest; SHOW DATABASES LIKE 'dbtest'\" | mysql --user=root --password=$MYSQL_ROOT_PASSWORD") do
            its(:stdout) { should match /dbtest/ }
            its(:stderr) { should eq "mysql: [Warning] Using a password on the command line interface can be insecure.\n" }
        end
    end

    describe "create user and run query" do
        describe command("echo \"CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'testpass'; GRANT ALL PRIVILEGES ON *.* TO 'testuser'@'localhost'; FLUSH PRIVILEGES; SELECT user, host FROM mysql.user\" | mysql --user=root --password=$MYSQL_ROOT_PASSWORD") do
            its(:stdout) { should match /testuser\tlocalhost/ }
            its(:stderr) { should match "mysql: [Warning] Using a password on the command line interface can be insecure.\n"}
        end
    end

    describe "check pma user exists" do
        describe command("echo \"SELECT user FROM mysql.user WHERE user='pma'\" | mysql --user=root --password=$MYSQL_ROOT_PASSWORD") do
            its(:stdout) { should match /pma/ }
            its(:stderr) { should eq "mysql: [Warning] Using a password on the command line interface can be insecure.\n" }
        end
    end
end
