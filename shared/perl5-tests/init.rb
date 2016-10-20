require 'rspec'
require 'serverspec'

RSpec.shared_examples "perl5-tests" do
#  describe "Container" do
    puts "Entered container" 
    puts "Checking UID" 
    describe command('id -u') do
      its(:stdout) { should match /^100000$/ }
    end

    describe file('/var/www/perl') do
      it { should be_directory }
    end

    cwd=Pathname.new(File.join(File.dirname(__FILE__)))

    ['perl','cgi-bin','html'].each do |dir|
      files = Dir["#{cwd}/files/#{dir}/*"]
      short_files = files.map { |f| File.basename(f) }
      puts "Transferring "#{short_files}" to directory /var/www/#{dir}"
      Specinfra::Runner.send_file( files, "/var/www/#{dir}/")
      puts "  Running #{dir} tests"
      short_files.each do |f|
        if dir == 'html'
          test = f
        else
         test = "#{dir}/#{f}"
	 `chmod 755 /var/www/#{dir}/#{f}`
       end
       puts "    Testing #{test}"
      describe command("curl -sS http://localhost:#{LISTEN_PORT}/#{test}") do
         its(:stdout) { should eq "Success" }
         its(:stderr) { should eq "" }
       end
     end
    end
  end
#end

