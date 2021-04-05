describe Spinup::Aws::Ec2 do

  describe '#run' do
    subject { described_class.new.run }
    xcontext 'when aws credentials are not available' do
      before do
        allow(ENV).to receive(:[]).with('AWS_ACCESS_KEY_ID').and_return(nil)
        allow(ENV).to receive(:[]).with('AWS_SECRET_ACCESS_KEY').and_return(nil)
      end

      it 'raises exception' do
        expect { subject }.to raise_exception
      end

    end
  end
end
