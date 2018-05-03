require 'spec_helper'

describe Subber::File::Srt do
  let(:subtitles) { [ double('Subber::Subtitle') ] }
  let(:srt_file) { Subber::File::Srt.new(subtitles: subtitles) }

  describe '#to_srt' do
    let(:vtt_file) { double('Subber::File::Vtt') }

    subject { srt_file.to_vtt }

    it 'instantiates a vtt file object' do
      expect(Subber::File::Vtt).to receive(:new)
        .with(subtitles: subtitles)
        .and_return(vtt_file)

      expect(subject).to eq(vtt_file)
    end
  end
end
