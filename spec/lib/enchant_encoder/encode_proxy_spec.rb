RSpec.describe FileEncoder::EncodeProxy do
  describe '#method_missing' do
    context 'when File' do
      let(:proxy) { FileEncoder::EncodeProxy.new(file) }

      context 'instance' do
        let(:file) { File.open(src_path('data-simple-sjis.txt')) }

        context '#each' do
          context 'block given' do
            it "yields converted string by NKF" do
              expect do |b|
                proxy.each(&b)
              end.to yield_successive_args("あああ\n", "いいい\n", "ううう\n")
            end
          end

          context 'no block given' do
            it do
              expect(proxy.each).to be_instance_of Enumerator
            end

            it "yields converted string by NKF" do
              enum = proxy.each
              expect do |b|
                enum.each(&b)
              end.to yield_successive_args("あああ\n", "いいい\n", "ううう\n")
            end
          end
        end

        context '#foreach' do
          it do
            expect do
              proxy.foreach
            end.to raise_error NoMethodError
          end
        end

        context '#open' do
          it do
            expect do
              proxy.open
            end.to raise_error NoMethodError
          end
        end
      end

      context 'class' do
        let(:file) { File }

        context '#each' do
          it do
            expect do
              proxy.each
            end.to raise_error NoMethodError
          end
        end

        context '#foreach' do
          context 'block given' do
            it "yields converted string by NKF" do
              expect do |b|
                proxy.foreach(src_path('data-simple-sjis.txt'), &b)
              end.to yield_successive_args("あああ\n", "いいい\n", "ううう\n")
            end
          end

          context 'no block given' do
            it do
              expect(proxy.foreach(src_path('data-simple-sjis.txt'))).to be_instance_of Enumerator
            end

            it "yields converted string by NKF" do
              enum = proxy.foreach(src_path('data-simple-sjis.txt'))
              expect do |b|
                enum.each(&b)
              end.to yield_successive_args("あああ\n", "いいい\n", "ううう\n")
            end
          end
        end

        context '#open' do
          context 'block given' do
            it "yields converted string by NKF" do
              expect do |b|
                proxy.open(src_path('data-simple-sjis.txt')) do |f|
                  f.each(&b)
                end
              end.to yield_successive_args("あああ\n", "いいい\n", "ううう\n")
            end
          end

          context 'no block given' do
            it do
              file = proxy.open(src_path('data-simple-sjis.txt'))
              expect(file).to be_instance_of File
            end

            it "yields converted string by NKF" do
              file = proxy.open(src_path('data-simple-sjis.txt'))
              expect do |b|
                file.each(&b)
              end.to yield_successive_args("あああ\n", "いいい\n", "ううう\n")
            end
          end
        end
      end
    end
  end
end
