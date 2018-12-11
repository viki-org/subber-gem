module Subber::File
  class Vtt < Base
    parser Subber::Parser::Vtt
    formatter Subber::Formatter::Vtt
  end
end
