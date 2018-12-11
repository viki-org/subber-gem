module Subber::File
  class Json < Base
    parser Subber::Parser::Json
    formatter Subber::Formatter::Json
  end
end
