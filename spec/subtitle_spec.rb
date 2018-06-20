describe Subber::Subtitle do
  let(:attributes) { raise NotImplementedError }
  let(:subtitle) { described_class.new(attributes) }

  describe '#as_json' do
    let(:attributes) do
      {
        counter: 1,
        start_time: 2000,
        end_time: 5000
      }
    end
    let(:expected_result) do
      {
        'counter' => 1,
        'start_time' => 2000,
        'end_time' => 5000,
        'content' => nil
      }
    end

    subject { subtitle.as_json }

    it 'returns the correct hash' do
      expect(subject).to eql(expected_result)
    end
  end

  describe '#shifted' do
    let(:attributes) do
      {
        counter: 1,
        start_time: 2000,
        end_time: 5000,
        content: 'another content'
      }
    end
    let(:shift_amount) { 3000 }
    subject { subtitle.shifted(shift_amount) }

    it 'does not change the original subtitle' do
      expect { subject }.not_to(change { subtitle })
    end

    it 'returns a subtitle with shifted' do
      expect(subject).to have_attributes(
        counter: subtitle.counter,
        start_time: subtitle.start_time + shift_amount,
        end_time: subtitle.end_time + shift_amount,
        content: subtitle.content
      )
    end
  end
end
