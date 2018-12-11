module Subber::Parser
  class Json < Base
    class << self
      # @param file_content [String]
      # @return [Array<Subber::Subtitle>]
      #
      def parse(file_content)
        subtitle_hashes = JSON.parse(file_content)

        subtitle_hashes.map.with_index do |subtitle_hash, index|
          counter = index + 1
          convert_subtitle_hash_to_subtitle(subtitle_hash, counter)
        end
      end

      private

      def convert_subtitle_hash_to_subtitle(unsafe_subtitle_hash, counter = nil)
        subtitle_hash = {}

        unsafe_subtitle_hash.each do |key, value|
          subtitle_hash[key.to_sym] = value
        end

        subtitle_options = { counter: counter }.merge(subtitle_hash)

        # TODO:
        # Move validation to model level
        #
        Subber::Subtitle.new(
          counter: parse_counter(subtitle_hash[:counter]),
          start_time: parse_timestamp(subtitle_hash[:start_time]),
          end_time: parse_timestamp(subtitle_hash[:end_time]),
          content: parse_content(subtitle_hash[:content])
        )
      end

      def parse_counter(raw_counter)
        counter = raw_counter.to_i

        if counter <= 0 || counter.to_s != raw_counter.to_s
          raise Subber::Errors::InvalidCounter
        end

        counter
      end

      def parse_timestamp(raw_timestamp)
        timestamp = raw_timestamp.to_i

        if timestamp <= 0 || timestamp.to_s != raw_timestamp.to_s
          raise Subber::Errors::InvalidTimestamp
        end

        timestamp
      end

      def parse_content(content)
        if content.to_s.strip.empty?
          raise Subber::Errors::InvalidContent
        end

        content
      end
    end
  end
end
