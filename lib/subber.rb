require 'json'

require 'subber/version'
require 'subber/errors'
require 'subber/subtitle'

# Formatters
#
require 'subber/formatter/base'
require 'subber/formatter/json'
require 'subber/formatter/srt'
require 'subber/formatter/vtt'
require 'subber/formatter/ttml'

# Parsers
#
require 'subber/parser/base'
require 'subber/parser/json'
require 'subber/parser/srt'
require 'subber/parser/vtt'
require 'subber/parser/ttml'

# Files
#
require 'subber/file/base'
require 'subber/file/json'
require 'subber/file/srt'
require 'subber/file/vtt'
require 'subber/file/ttml'
require 'subber/file'

module Subber; end
