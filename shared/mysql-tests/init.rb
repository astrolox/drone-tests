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

    describe "check cgroup limit is set" do
        describe file('/sys/fs/cgroup/memory/memory.limit_in_bytes') do
            it { should exist }
        end
    end

    describe "check limits set in sql" do
    #export MYSQL_INNODB_LOG_FILE_SIZE=${MYSQL_INNODB_LOG_FILE_SIZE:-$((MEMORY_LIMIT_IN_BYTES*15/1024/1024/100))M}
#    MEMORY_LIMIT_IN_BYTES = File.read("/sys/fs/cgroup/memory/memory.limit_in_bytes").to_i
#    puts MEMORY_LIMIT_IN_BYTES
#    LOGSIZE = (MEMORY_LIMIT_IN_BYTES*15 / 1024 / 1024 / 100)
#    puts LOGSIZE
        describe file('/etc/mysql/my.cnf') do
            it { should exist }
            let(:MEMORY_LIMIT) { File.read("/sys/fs/cgroup/memory/memory.limit_in_bytes")}
            puts MEMORY_LIMIT
            LOGSIZE = MEMORY_LIMIT*15 / 1024 / 1024 / 100
            puts LOGSIZE
            it { should contain /#{LOGSIZE}/}
        end
    end
end
