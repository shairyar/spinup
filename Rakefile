require './config/boot'
namespace :spinup do
  desc 'Spin up an instance'
  task :run do
    Spinup::Aws::Ec2.new.run
  end

  desc 'List running instances'
  task :list do
    Spinup::Aws::Ec2.new.print_current_instance
  end

  desc 'Stop all running instances'
  task :stop_all do
    Spinup::Aws::Ec2.new.stop_all_instances
  end
end



