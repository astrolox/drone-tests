require 'rspec'
require 'serverspec'

RSpec.shared_examples "mod_perl-tests" do
  describe "Container" do

    describe command('id -u') do
      its(:stdout) { should match /^100000$/ }
    end

    cwd=Pathname.new(File.join(File.dirname(__FILE__)))

    ['perl','cgi-bin','html'].each do |dir|
      files = Dir["#{cwd}/files/#{dir}/*"]
      short_files = files.map { |f| File.basename(f) }
      puts "Transferring #{dir} files to container: #{short_files}"
      Specinfra::Runner.send_file( files, "/var/www/#{dir}/")
      puts "  Running #{dir} tests"
      short_files.each do |f|
        if dir == 'html'
          test = f
        else
          test = "#{dir}/#{f}"
        end
        puts "    Testing #{test}"
        describe command("curl -sS http://localhost:#{LISTEN_PORT}/#{test}") do
          its(:stdout) { should eq "Success" }
          its(:stderr) { should eq "" }
        end
      end
    end
  end
end

