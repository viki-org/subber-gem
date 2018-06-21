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

    def shift!(ms)
      subtitles.each { |subtitle| subtitle.shift!(ms) }
    end

    private

    def formatter
      self.class.formatter_klass
    end
  end
end
