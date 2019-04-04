require 'spec_helper'

describe Subber::Parser::Ttml do
  describe '.parse' do
    subject { described_class.parse(content) }

    context 'valid content' do
      let(:content) { read_fixture('ttml-sample.xml') }
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
