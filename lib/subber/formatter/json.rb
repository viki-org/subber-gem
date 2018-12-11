module Subber::Formatter
  class Json < Base
    class << self
      # @param subtitles [Array<Subber::Subtitle>]
      # @return [String]
      #
      def format(subtitles)
        subtitle_hashes = subtitles.map(&:as_json)
        JSON.generate(subtitle_hashes)
      end
    end
  end
end
