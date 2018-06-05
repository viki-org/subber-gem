require 'spec_helper'

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
end
