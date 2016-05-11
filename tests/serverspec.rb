require "serverspec"
require "docker"

#Include Tests
base_spec_dir = Pathname.new(File.join(File.dirname(__FILE__)))
Dir[base_spec_dir.join('shared/**/*.rb')].sort.each{ |f| require_relative f }
#require_relative "shared/docker-ubuntu-16/init.rb"

describe "Dockerfile" do
  before(:all) do
    @image = Docker::Image.get(ENV['IMAGE'])

    set :backend, :docker
    set :docker_image, @image.id
  end

  #Begin Tests
  include_examples 'docker-ubuntu-16'

  #End Tests
end


