describe Spinup::Aws::Ec2 do

  describe "#run" do
    subject { described_class.new.run }
    context "config is not available" do
      it { is_expected.to eq(nil) }
    end
  end
end
