require 'rspec'
require 'serverspec'

logsize = 0

RSpec.shared_examples "mariadb-tests" do

    describe package(PACKAGE_NAME) do
        it { should be_installed }
    end

    describe service('mysql') do
      it { should be_enabled }
      it { should be_running }
    end

    describe group('mysql') do
        it { should exist }
    end

    describe user('mysql') do
        it { should exist }
        it { should belong_to_group 'mysql' }
    end

    describe "create database" do
        describe command("echo \"DROP DATABASE IF EXISTS dbtest; CREATE DATABASE dbtest; SHOW DATABASES LIKE 'dbtest'\" | mysql --user=root --password=$MYSQL_ROOT_PASSWORD") do
            its(:stdout) { should match /dbtest/ }
            its(:stderr) { should eq "" }
        end
    end

    describe "create user and run query" do
        describe command("echo \"CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'testpass'; GRANT ALL PRIVILEGES ON *.* TO 'testuser'@'localhost'; FLUSH PRIVILEGES; SELECT user, host FROM mysql.user WHERE user='testuser' AND host='localhost' \" | mysql --user=root --password=$MYSQL_ROOT_PASSWORD") do
            its(:stdout) { should match /testuser\tlocalhost/ }
            its(:stderr) { should eq "" }
        end
    end

    describe "check pma user exists" do
        describe command("echo \"SELECT user FROM mysql.user WHERE user='pma'\" | mysql --user=root --password=$MYSQL_ROOT_PASSWORD") do
            its(:stdout) { should match /pma/ }
            its(:stderr) { should eq "" }
        end
    end

    describe "check cgroup limit is set" do
        describe file('/sys/fs/cgroup/memory/memory.limit_in_bytes') do
            it { should exist }
        end
    end

    describe command('cat /sys/fs/cgroup/memory/memory.limit_in_bytes') do
      it "should contain a value" do
        expect(subject.stdout).to match(/[0-9]{1,9}/)
        memory = subject.stdout.to_i
        logsize = (memory*15 / 1024 / 1024 / 100).to_i
      end
    end

    describe "check limits set in sql" do
      describe file('/etc/mysql/mariadb.conf.d/50-server.cnf') do
        it { should exist }
        it { should contain /innodb_log_file_size    = #{logsize}M/}
      end
    end
end
