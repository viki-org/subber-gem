require 'open-uri'

class Subber::Base
  @@parser_klasses = {}

  class << self
    def parser(parser_klass)
      @@parser_klasses[to_s] = parser_klass
    end
  end

  attr_reader :path

  # @param path [String] URI or local file path
  #
  def initialize(path)
    @path = path
  end

  # @return [String] content of the file
  #
  def content
    @content ||= open(path).read
  end

  # @return [Array<Subber::Subtitle>]
  #
  def subtitles
    @subtitles ||= parser_klass.parse(content)
  end

  def vtt_content
    vtt_exporter.content
  end

  def srt_content
    srt_exporter.content
  end

  def to_vtt(destination)
    vtt_exporter.export(destination)
  end

  def to_srt(destination)
    srt_exporter.export(destination)
  end

  private

  def vtt_exporter
    @vtt_exporter ||= Subber::Exporter::Vtt.new(subtitles)
  end

  def srt_exporter
    @srt_exporter ||= Subber::Exporter::Srt.new(subtitles)
  end

  def parser_klass
    @@parser_klasses[self.class.to_s]
  end
end
