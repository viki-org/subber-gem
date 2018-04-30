module Subber::File
  class Vtt < Base
    parser Subber::Parser::Vtt
    formatter Subber::Formatter::Vtt

    # @return [Subber::File::Srt]
    #
    def to_srt
      Subber::File::Srt.new(subtitles: subtitles)
    end
  end
end
