describe Spinup::Aws::Ec2 do
  describe '#run' do
    let(:ec2_collection) {::Aws::EC2::Instance::Collection}
    subject { described_class.new.run }
    context 'when the image_id is not available' do
      before do
        allow(ENV).to receive(:[]).with('OS').and_return(nil)
      end

      it 'raises exception' do
        expect { subject }.to raise_exception
      end
    end

    # xcontext 'when the image id is available' do
    #   it { is_expected.to be_a(::Aws::EC2::Instance::Collection) }
    #   it { is_expected.to be_an_instance_of(ec2_collection) }
    # end
  end
end
