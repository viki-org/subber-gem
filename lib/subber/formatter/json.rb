module Subber::Formatter
  class Json < Base
    class << self
      # @param subtitles [Array<Subber::Subtitle>]
      # @return [String]
      #
      def format(subtitles)
        subtitles.map(&:as_json).to_json
      end
    end
  end
end
