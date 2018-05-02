require 'spec_helper'

describe Subber::Parser::Vtt do
  describe '.parse' do
    let(:content) { read_fixture('vtt-sample.vtt') }

    it 'generates subtitles based on the file content' do
      subtitles = described_class.parse(content)
      expect(subtitles).to_not be_empty

      subtitle1, subtitle2 = subtitles

      expect(subtitle1).to have_attributes(
        counter: 1,
        start_time: 500,
        end_time: 4000,
        content: 'this is a sample',
      )

      expect(subtitle2).to have_attributes(
        counter: 2,
        start_time: 4099,
        end_time: 6000,
        content: 'subtitle for subber gem',
      )
    end
  end
end
