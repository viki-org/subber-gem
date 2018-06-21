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

  describe '#shift' do
    let(:attributes) do
      {
        counter: 1,
        start_time: 2000,
        end_time: 5000,
        content: 'some content'
      }
    end
    let(:shift_amount) { 3000 }
    subject { subtitle.shift(shift_amount) }

    it 'does not change the original subtitle' do
      expect { subject }.not_to(change { subtitle })
    end

    it 'returns a subtitle with shifted' do
      expect(subject).to have_attributes(
        counter: 1,
        start_time: 5000,
        end_time: 8000,
        content: 'some content'
      )
    end
  end

  describe '#shift!' do
    let(:attributes) do
      {
        counter: 1,
        start_time: 1000,
        end_time: 6000,
        content: 'another content'
      }
    end
    let(:shift_amount) { 1500 }
    subject { subtitle.shift!(shift_amount) }

    it { is_expected_block.not_to change(subtitle, :counter) }
    it { is_expected_block.to change(subtitle, :start_time).by(shift_amount) }
    it { is_expected_block.to change(subtitle, :end_time).by(shift_amount) }
    it { is_expected_block.not_to change(subtitle, :content) }
  end
end
