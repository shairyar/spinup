module Ec2SpecHelper
  def create_ec2_collection
    ::Aws::EC2::Instance::Collection.new([create_ec2_instance])
  end

  def create_ec2_instance
    params = { id: 'i-abc', region: 'eu-west-1', data: {instance_id: 'instance_id', image_id: 'image_id' } }
    ::Aws::EC2::Instance.new(params)
  end

  def create_instance_state
    state = Struct.new(:code, :name)
    state_instance = state.new(0, 'pending')
    ::Aws::EC2::Types::InstanceState.new(state_instance)
  end
end
