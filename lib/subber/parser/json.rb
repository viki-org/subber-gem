module Subber::Parser
  class Json < Base
    class << self
      # @param file_content [String]
      # @return [Array<Subber::Subtitle>]
      #
      def parse(file_content)
        subtitle_hashes = JSON.parse(content)

        subtitle_hashes.map.with_index do |subtitle_hash, index|
          counter = index + 1
          convert_subtitle_hash_to_subtitle(subtitle_hash, counter)
        end
      end
    end
  end
end
