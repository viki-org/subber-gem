require 'open-uri'

module Subber::File
  class Base
    class << self
      attr_reader :parser_klass
      attr_reader :formatter_klass

      # @param value [Class] class to be used as parser
      #
      def parser(value = nil)
        @parser_klass = value unless value.nil?
      end

      # @param value [Class] class to be used as formatter
      #
      def formatter(value = nil)
        @formatter_klass = value unless value.nil?
      end

      # @param content [String]
      # @return [Subber::File::Base]
      #
      def from_content(content)
        subtitles = parser_klass.parse(content)
        new(subtitles: subtitles)
      end

      # @param path [String]
      # @return [Subber::File::Base]
      #
      def from_path(path)
        content = open(path).read
        from_content(content)
      end
    end

    attr_reader :subtitles

    # @param [Hash]
    # @param subtitles [Array<Subber::Subtitle>]
    #
    def initialize(subtitles: nil)
      @subtitles = subtitles
    end

    # @return [String]
    #
    def content
      @content ||= formatter.format(subtitles)
    end

    # @param path [String] Remote or local file path
    #
    def export(path)
      File.write(path, content)
    end

    # @param ms [Integer] Can be both positive and negative
    # @return [Subber::File::Base] return a new copy with shifted subtitles
    #
    def shift(ms)
      new_subtitles = subtitles.map { |subtitle| subtitle.shift(ms) }
      self.class.new(subtitles: new_subtitles)
    end

    # @param ms [Integer] Can be both positive and negative
    # mutates the current file's subtitles
    #
    def shift!(ms)
      subtitles.each { |subtitle| subtitle.shift!(ms) }
    end

    def to_file_type(file_type)
      case file_type
      when 'srt'
        to_srt
      when 'json'
        to_json
      when 'vtt'
        to_vtt
      when 'ttml'
        to_ttml
      else
        message = "#{file_type} is not a supported file type"
        raise(Subber::Errors::NotSupported, message)
      end
    end

    # @return [Subber::File::Json]
    #
    def to_json
      Subber::File::Json.new(subtitles: subtitles)
    end

    # @return [Subber::File::Srt]
    #
    def to_srt
      Subber::File::Srt.new(subtitles: subtitles)
    end

    # @return [Subber::File::Vtt]
    #
    def to_vtt
      Subber::File::Vtt.new(subtitles: subtitles)
    end

    # @return [Subber::File::Ttml]
    #
    def to_ttml
      Subber::File::Ttml.new(subtitles: subtitles)
    end

    private

    def formatter
      self.class.formatter_klass
    end
  end
end
