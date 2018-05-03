require 'spec_helper'

describe Subber::File::Vtt do
  let(:subtitles) { [ double('Subber::Subtitle') ] }
  let(:vtt_file) { Subber::File::Vtt.new(subtitles: subtitles) }

  describe '#to_srt' do
    let(:srt_file) { double('Subber::File::Srt') }

    subject { vtt_file.to_srt }

    it 'instantiates an srt file object' do
      expect(Subber::File::Srt).to receive(:new)
        .with(subtitles: subtitles)
        .and_return(srt_file)

      expect(subject).to eq(srt_file)
    end
  end
end
