require './config/boot'
task default: %w[spinup]

task :spinup do
  Spinup::Aws::Ec2.new
end

task :test do
  ruby 'test/unittest.rb'
end
