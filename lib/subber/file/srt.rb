module Subber::File
  class Srt < Base
    parser Subber::Parser::Srt
    formatter Subber::Formatter::Srt
  end
end
