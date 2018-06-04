describe Subber::Subtitle do
  let(:attributes) { raise NotImplementedError }
  subject { described_class.new(attributes) }

  describe 'to_hash' do
    context 'when there is missing attribute' do
      let(:attributes) do
        {
          start_time: 1000,
          end_time: 3000,
          content: 'some content'
        }
      end

      it 'does not include the missing attribute to the hash' do
        expect(subject.to_hash.key?(:counter)).to be_falsey
      end

      it 'returns the right hash' do
        expect(subject.to_hash).to eq(
          start_time: 1000,
          end_time: 3000,
          content: 'some content'
        )
      end
    end

    context 'when there are no missing attributes' do
      let(:attributes) do
        {
          counter: 1,
          start_time: 2000,
          end_time: 5000,
          content: 'another content'
        }
      end

      it 'returns the right hash' do
        expect(subject.to_hash).to eq(
          counter: 1,
          start_time: 2000,
          end_time: 5000,
          content: 'another content'
        )
      end
    end
  end
end
