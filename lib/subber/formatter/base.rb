module Subber::Formatter
  class Base
    class << self
      # @param subtitles [Array<Subber::Subtitle>]
      # @return [String]
      #
      def format(_subtitles)
        raise NotImplementedError
      end
    end
  end
end
