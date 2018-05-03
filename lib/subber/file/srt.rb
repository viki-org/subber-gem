module Subber::File
  class Srt < Base
    parser Subber::Parser::Srt
    formatter Subber::Formatter::Srt

    # @return [Subber::File::Vtt]
    #
    def to_vtt
      Subber::File::Vtt.new(subtitles: subtitles)
    end
  end
end
