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

  describe '#content' do
    let(:subtitles) { [Subber::Subtitle.new(counter: 1, start_time: 500, end_time: 4000, content: 'hello')] }

    it 'formats without cue settings by default' do
      expect(vtt_file.content).to eq("WEBVTT\r\n\r\n1\r\n00:00:00.500 --> 00:00:04.000\r\nhello\r\n\r\n")
    end

    it 'formats with cue settings when given' do
      file = Subber::File::Vtt.new(subtitles: subtitles, cue_settings: 'line:70%')

      expect(file.content).to eq("WEBVTT\r\n\r\n1\r\n00:00:00.500 --> 00:00:04.000 line:70%\r\nhello\r\n\r\n")
    end
  end

  describe '#shift' do
    let(:subtitles) { [Subber::Subtitle.new(counter: 1, start_time: 500, end_time: 4000, content: 'hello')] }

    it 'keeps the cue settings' do
      file = Subber::File::Vtt.new(subtitles: subtitles, cue_settings: 'line:70%')

      expect(file.shift(1000).content).to include('00:00:01.500 --> 00:00:05.000 line:70%')
    end

    it 'returns a file without cue settings when none were given' do
      expect(vtt_file.shift(1000).cue_settings).to be_nil
    end
  end
end
