module Spinup
  module Aws
    class Ec2
      DEFAULT_IMAGE = 'ubuntu'.freeze
      DEFAULT_REGION = 'eu-west-1'.freeze
      INSTANCE_TYPE = 't2.micro'.freeze

      def initialize; end

      def run
        instance = create_ec2_instance

        # Check whether the new instance is in the "running" state.
        check_instance_state(instance)

        install_dependencies
      end

      def print_current_instance
        Spinup.logger.info('Fetching current instances')
        tp ec2.instances, "image_id", "instance_type", "state"
      end

      def stop_all_instances
        Spinup.logger.info('Attempting to stop all running instances')
        running_instances = ec2.instances

        Spinup.logger.info("#{running_instances.count} running instances")

        running_instances.each do |running_instance|
          instance_stopped?(running_instance)
        end
      end

      private

      def config
        Spinup.logger.info('Reading the config file')
        YAML.load(File.read('config/spinup.yml'))
      end

      def create_ec2_instance
        Spinup.logger.debug("Creating ec2 instance with image_id: #{image_id}")
        ec2.create_instances( image_id: image_id, instance_type: INSTANCE_TYPE, max_count: 1, min_count: 1, key_name: 'key_pair_name' )
      end

      def check_instance_state(instance)
        Spinup.logger.info('Checking instance status')
        polls = 0
        loop do
          polls += 1
          response = ec2.client.describe_instances( instance_ids: [ instance.first.id ] )
          state = response.reservations[0].instances[0].state.name
          Spinup.logger.debug("Instance stage: #{state}")

          # Stop polling after 10 minutes (40 polls * 15 seconds per poll) if not running.
          break if state == 'running' || polls > 40

          sleep(15)
        end

        puts "Instance created with ID '#{instance.first.id}'."
        return instance
      end

      def ec2
        ::Aws::EC2::Resource.new(region: DEFAULT_REGION)
      end

      def image_id
        image = ENV['OS'] || DEFAULT_IMAGE
        config['aws'][image.to_s]['image_id']
      end

      def instance_stopped?(instance)
        # response = ec2.describe_instance_status(instance_ids: [instance_id])
        state = instance.state.name
        case state
        when 'stopping'
          puts "Instance #{instance.id} is already stopping."
          return true
        when 'stopped'
          puts "The instance #{instance.id} is already stopped."
          return true
        when 'terminated'
          puts "Error stopping instance #{instance.id}, the instance is terminated, so you cannot stop it."
          return false
        end
        Spinup.logger.debug("Attempting to stop the instance: #{instance.id}")
        ec2.client.stop_instances(instance_ids: [instance.id])
        ec2.client.wait_until(:instance_stopped, instance_ids: [instance.id])
        Spinup.logger.debug("Instance stopped: #{instance.id}")
        return true
      rescue StandardError => e
        puts "Error stopping instance: #{e.message}"
        return false
      end

      def install_dependencies
        # code here
      end

    end

    class AwsAccessKeyError < StandardError; end

    class AwsSecretAccessError < StandardError; end
  end
end
