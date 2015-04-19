RSpec.describe FileEncoder::EncodeProxy do
  describe '#initialize' do
    context 'when object is File instance' do
      let(:proxy) { FileEncoder::EncodeProxy.new(file) }
      let(:file) { File.open(src_path('data-simple-sjis.txt')) }

      context 'File#each' do
        it "yields converted string by NKF" do
          expect do |b|
            proxy.each(&b)
          end.to yield_successive_args("あああ\n", "いいい\n", "ううう\n")
        end
      end
    end
  end
end
