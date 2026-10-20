require 'spec_helper'

describe Subber::Formatter::Vtt do
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
    let(:expected_content) { read_fixture('vtt-sample.vtt') }

    subject { described_class.format(subtitles) }

    it { should eq(expected_content) }

    context 'with cue settings' do
      let(:cue_settings) { 'position:50% align:center line:70%,end' }

      subject { described_class.format(subtitles, cue_settings: cue_settings) }

      it 'appends the settings to every cue timing line only' do
        expect(subject).to eq(
          "WEBVTT\r\n\r\n" \
          "1\r\n00:00:00.500 --> 00:00:04.000 #{cue_settings}\r\nthis is a sample\r\n\r\n" \
          "2\r\n00:00:04.099 --> 00:00:06.000 #{cue_settings}\r\nsubtitle for subber gem\r\n\r\n"
        )
      end

      [nil, '', '  '].each do |blank|
        context "when cue settings is #{blank.inspect}" do
          let(:cue_settings) { blank }

          it { should eq(expected_content) }
        end
      end
    end
  end
end
