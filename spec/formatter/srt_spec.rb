require 'spec_helper'

describe Subber::Formatter::Srt do
  describe '.format' do
    let(:subtitle1) do
      Subber::Subtitle.new(
        counter: 1,
        start_time: 500,
        end_time: 4000,
        content: 'this is a sample',
      )
    end
    let(:subtitle2) do
      Subber::Subtitle.new(
        counter: 2,
        start_time: 4099,
        end_time: 6000,
        content: 'subtitle for subber gem',
      )
    end
    let(:subtitles) { [subtitle1, subtitle2] }
    let(:expected_content) { read_fixture('srt-sample.srt') }

    subject { described_class.format(subtitles) }

    it { should eq(expected_content) }
  end
end
