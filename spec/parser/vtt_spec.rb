require 'spec_helper'

describe Subber::Parser::Vtt do
  describe '.parse' do
    let(:expected_attribute_hashes) do
      [
        {
          counter: 1,
          start_time: 500,
          end_time: 4000,
          content: 'this is a sample',
        },
        {
          counter: 2,
          start_time: 4099,
          end_time: 6000,
          content: 'subtitle for subber gem',
        }
      ]
    end

    subject { described_class.parse(content) }

    context 'invalid content' do
      let(:content) { read_fixture('vtt-sample-invalid.vtt') }

      it 'raises error' do
        expect { subject }.to raise_error(Subber::Errors::InvalidVttFormat)
      end
    end

    context 'with counter' do
      let(:content) { read_fixture('vtt-sample.vtt') }

      it 'generates subtitles based on the file content' do
        subtitles = subject

        subtitles.each_with_index do |subtitle, index|
          attribute_hash = expected_attribute_hashes[index]
          expect(subtitle).to have_attributes(attribute_hash)
        end
      end
    end

    context 'without counter' do
      let(:content) { read_fixture('vtt-without-counter-sample.vtt') }

      it 'generates subtitles based on the file content' do
        subtitles = subject

        subtitles.each_with_index do |subtitle, index|
          attribute_hash = expected_attribute_hashes[index]
          expect(subtitle).to have_attributes(attribute_hash)
        end
      end
    end

    context 'with different settings' do
      let(:content) { read_fixture('vtt-with-different-settings-sample.vtt') }

      it 'generates subtitles based on the file content' do
        subtitles = subject

        subtitles.each_with_index do |subtitle, index|
          attribute_hash = expected_attribute_hashes[index]
          expect(subtitle).to have_attributes(attribute_hash)
        end
      end
    end

    context 'with cue settings on the timing line' do
      let(:content) { read_fixture('vtt-with-cue-settings-sample.vtt') }

      it 'ignores the settings and parses the cues' do
        expect(subject.size).to eq(expected_attribute_hashes.size)

        subject.each_with_index do |subtitle, index|
          expect(subtitle).to have_attributes(expected_attribute_hashes[index])
        end
      end

      it 'parses the same as the output of the formatter with cue settings' do
        formatted = Subber::Formatter::Vtt.format(described_class.parse(read_fixture('vtt-sample.vtt')), cue_settings: 'line:70%')

        expect(described_class.parse(formatted).map(&:as_json)).to eq(described_class.parse(read_fixture('vtt-sample.vtt')).map(&:as_json))
      end

      it 'accepts settings separated by a tab' do
        content = "WEBVTT\n\n1\n00:00:00.500 --> 00:00:04.000\tline:70%\nhello\n\n"

        expect(described_class.parse(content).first).to have_attributes(start_time: 500, end_time: 4000, content: 'hello')
      end
    end

    context 'with trailing whitespace only after the timing line' do
      let(:content) { "WEBVTT\n\n1\n00:00:00.500 --> 00:00:04.000  \nhello\n\n" }

      it 'still raises error, as before' do
        expect { subject }.to raise_error(Subber::Errors::InvalidVttFormat)
      end
    end

    context 'with text directly after the end timestamp' do
      let(:content) { "WEBVTT\n\n1\n00:00:00.500 --> 00:00:04.000x\nhello\n\n" }

      it 'still raises error, as before' do
        expect { subject }.to raise_error(Subber::Errors::InvalidVttFormat)
      end
    end
  end
end
