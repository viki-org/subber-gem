# Timed Text Markup Language 1
#
module Subber::File
  class Ttml < Base
    parser Subber::Parser::Ttml
    formatter Subber::Formatter::Ttml
  end
end
