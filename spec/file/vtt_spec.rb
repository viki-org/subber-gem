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

  describe '#to_vtt' do
    let(:subtitles) { [Subber::Subtitle.new(counter: 1, start_time: 500, end_time: 4000, content: 'hello')] }
    let(:timing) { '00:00:00.500 --> 00:00:04.000' }
    let(:file_with_settings) { Subber::File::Vtt.new(subtitles: subtitles, cue_settings: 'line:70%') }

    it 'keeps its own cue settings by default' do
      expect(file_with_settings.to_vtt.content).to include("#{timing} line:70%")
    end

    it 'replaces its cue settings when given new ones' do
      expect(file_with_settings.to_vtt(cue_settings: 'align:start').content)
        .to include("#{timing} align:start")
    end

    it 'clears its cue settings when given an empty string' do
      content = file_with_settings.to_vtt(cue_settings: '').content

      expect(content).to include("#{timing}\r\n")
      expect(content).not_to include('line:70%')
    end

    it 'has no cue settings when it had none' do
      expect(vtt_file.to_vtt.cue_settings).to be_nil
      expect(vtt_file.to_vtt.content).to include("#{timing}\r\n")
    end

    it 'applies given cue settings when it had none' do
      expect(vtt_file.to_vtt(cue_settings: 'line:70%').content).to include("#{timing} line:70%")
    end

    it 'is used by to_file_type' do
      expect(file_with_settings.to_file_type('vtt').content).to include("#{timing} line:70%")
      expect(file_with_settings.to_file_type('vtt', cue_settings: '').content).to include("#{timing}\r\n")
    end
  end
end
