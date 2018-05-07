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
  end
end
