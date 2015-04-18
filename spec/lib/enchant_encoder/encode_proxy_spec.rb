RSpec.describe FileEncoder::EncodeProxy do
  describe '#initialize' do
    context 'when File' do
      let(:proxy) { FileEncoder::EncodeProxy.new(file) }

      context 'instance' do
        let(:file) { File.open(src_path('data-simple-sjis.txt')) }

        context '#each' do
          it "yields converted string by NKF" do
            expect do |b|
              proxy.each(&b)
            end.to yield_successive_args("あああ\n", "いいい\n", "ううう\n")
          end
        end
      end

      context 'class' do
        let(:file) { File }

        context '#foreach' do
          it "yields converted string by NKF" do
            expect do |b|
              proxy.foreach(src_path('data-simple-sjis.txt'), &b)
            end.to yield_successive_args("あああ\n", "いいい\n", "ううう\n")
          end
        end
      end
    end
  end
end