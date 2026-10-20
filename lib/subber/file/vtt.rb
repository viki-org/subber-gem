module Subber::File
  class Vtt < Base
    parser Subber::Parser::Vtt
    formatter Subber::Formatter::Vtt

    attr_reader :cue_settings

    # @param subtitles [Array<Subber::Subtitle>]
    # @param cue_settings [String, nil] see Subber::Formatter::Vtt.format
    #
    def initialize(subtitles: nil, cue_settings: nil)
      super(subtitles: subtitles)
      @cue_settings = cue_settings
    end

    # @return [String]
    #
    def content
      @content ||= cue_settings.nil? ? formatter.format(subtitles) : formatter.format(subtitles, cue_settings: cue_settings)
    end

    # @param cue_settings [String, nil] nil keeps this file's cue settings; any other value
    #   replaces them (use '' to clear)
    # @return [Subber::File::Vtt]
    #
    def to_vtt(cue_settings: nil)
      super(cue_settings: cue_settings.nil? ? self.cue_settings : cue_settings)
    end

    # @param ms [Integer] Can be both positive and negative
    # @return [Subber::File::Vtt] return a new copy with shifted subtitles, keeping the cue settings
    #
    def shift(ms)
      return super if cue_settings.nil?

      new_subtitles = subtitles.map { |subtitle| subtitle.shift(ms) }
      self.class.new(subtitles: new_subtitles, cue_settings: cue_settings)
    end
  end
end
