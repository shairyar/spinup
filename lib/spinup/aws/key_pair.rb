module Spinup
  module Aws
    class KeyPair

      KEY_PAIR_NAME = 'key_pair_name'.freeze
      DEFAULT_REGION = 'eu-west-1'.freeze

      def create
        key_pair = ec2_client.create_key_pair(key_name: KEY_PAIR_NAME)

        puts "Created key pair '#{key_pair.key_name}' with fingerprint " \
    "'#{key_pair.key_fingerprint}' and ID '#{key_pair.key_pair_id}'."
        filename = File.join("#{KEY_PAIR_NAME}.pem")

        File.open(filename, 'w') { |file| file.write(key_pair.key_material) }
        puts "Private key file saved locally as '#{filename}'."
        return true
      rescue ::Aws::EC2::Errors::InvalidKeyPairDuplicate
        puts "Error creating key pair: a key pair named '#{KEY_PAIR_NAME}' " \
    'already exists.'
        return false
      rescue StandardError => e
        puts "Error creating key pair or saving private key file: #{e.message}"
        return false
      end

      def ec2_client
        ::Aws::EC2::Resource.new(region: DEFAULT_REGION).client
      end

    end
  end
end
