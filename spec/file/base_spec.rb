require 'spec_helper'

describe Subber::File::Base do
  describe '.from_content' do
    let(:parser_klass) { Subber::Parser::Vtt }
    let(:content) { 'some-random-content' }
    let(:subtitles) { [ double('Subber::Subtitle') ] }

    before do
      allow(described_class).to receive(:parser_klass).and_return(parser_klass)
    end

    subject { described_class.from_content(content) }

    it 'parses the content and instantiates a Subber::File::Base instance' do
      expect(parser_klass).to receive(:parse).with(content).and_return(subtitles)
      expect(described_class).to receive(:new).with(subtitles: subtitles)
      subject
    end
  end

  describe '.from_path' do
    let(:parser_klass) { Subber::Parser::Vtt }
    let(:path) { 'https://some-random-content.vtt' }
    let(:content) { 'some-random-content' }
    let(:string_io) { double('StringIO', read: content) }

    subject { described_class.from_path(path) }

    it 'reads the file and parses the content' do
      expect(described_class).to receive(:open).with(path).and_return(string_io)
      expect(described_class).to receive(:from_content).with(content)
      subject
    end
  end

  let(:subtitles) { [double('Subber::Subtitle')] }
  let(:file) { described_class.new(subtitles: subtitles) }

  describe '#content' do
    let(:formatter) { double('Subber::Formatter::Vtt') }

    subject { file.content }

    before do
      allow(file).to receive(:formatter).and_return(formatter)
    end

    it 'uses the formatter to generate the content based on subtitles' do
      expect(formatter).to receive(:format).with(subtitles)
      subject
    end
  end

  describe '#export' do
    let(:content) { 'some-vtt-content-here' }
    let(:path) { '/some/random/path/test.vtt' }

    subject { file.export(path) }

    before do
      allow(file).to receive(:content).and_return(content)
    end

    it 'exports the content of the file' do
      expect(File).to receive(:write).with(path, content)
      subject
    end
  end

  describe '#shift' do
    let(:shift_amount) { 3000 }
    let(:shifted_subtitle) { double('shifted_subtitle') }

    subject { file.shift(shift_amount) }

    before do
      subtitles.each do |subtitle|
        allow(subtitle)
          .to receive(:shift)
          .with(shift_amount)
          .and_return(shifted_subtitle)
      end
    end

    it 'does not change the original file' do
      expect { subject }.not_to(change { file })
    end

    it 'calls shift on each subtitles' do
      subject

      subtitles.each do |subtitle|
        expect(subtitle)
          .to have_received(:shift)
          .with(shift_amount)
      end
    end

    it 'returns a new base with shifted subtitles' do
      expect(subject.subtitles).to match_array([shifted_subtitle])
    end
  end

  describe '#shift!' do
    let(:shift_amount) { 1500 }

    subject { file.shift!(shift_amount) }

    it 'shifts its own subtitle' do
      subtitles.each do |subtitle|
        expect(subtitle).to receive(:shift!).with(shift_amount)
      end

      subject
    end
  end
end
