module Spinup
  module Aws
    class Ec2
      DEFAULT_IMAGE = 'ubuntu'.freeze

      def initialize; end

      def run
        print_current_instance
        # create_ec2_instance
      end

      private

      def config
        Spinup.logger.info('Reading the config file')
        YAML.load(File.read('config/spinup.yml'))
      end

      def create_ec2_instance
        Spinup.logger.debug("Creating ec2 instance with image_id: #{image_id}")

        # ec2.instances
        instance = ec2.create_instances(
          image_id: image_id,
          instance_type: 't2.micro',
          max_count: 1,
          min_count: 1
        )

        # Check whether the new instance is in the "running" state.
        check_instance_state(instance)
      end

      def check_instance_state(instance)
        Spinup.logger.info('Checking instance status')
        polls = 0
        loop do
          polls += 1
          response = ec2.client.describe_instances(
            instance_ids: [
              instance.first.id
            ]
          )
          state = response.reservations[0].instances[0].state.name
          Spinup.logger.debug("Instance stage: #{state}")
          # Stop polling after 10 minutes (40 polls * 15 seconds per poll) if not running.
          break if state == 'running' || polls > 40

          sleep(15)
        end

        puts "Instance created with ID '#{instance.first.id}'."
      end

      def ec2
        ::Aws::EC2::Resource.new(region: 'eu-west-1')
      end

      def image_id
        image = ENV['OS'] || DEFAULT_IMAGE
        config['aws'][image.to_s]['image_id']
      end

      def print_current_instance
        Spinup.logger.info('Fetching current instances')
        tp ec2.instances, "image_id", "instance_type", "state"
      end

    end

    class AwsAccessKeyError < StandardError; end

    class AwsSecretAccessError < StandardError; end
  end
end
