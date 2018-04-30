module Subber::Parser
  class Srt < Base
    SUBTITLE_REGEX = /([^\n]*)\n([^\n]*)(\n(.*))?/m
    COUNTER_REGEX = /\d+/
    TIME_RANGE_REGEX = /(\d{2}:\d{2}:\d{2},\d{3})\s*-->\s*(\d{2}:\d{2}:\d{2},\d{3})/
    TIMECODE_REGEX = /(\d{2}):(\d{2}):(\d{2}),(\d{3})/

    DELIMITER_REGEX = /\n?\n\n/
    WINDOW_LINE_BREAK_REGEX = /\r/
    BYTE_ORDER_MARK_STRING = "\xEF\xBB\xBF"

    class << self
      # @param content [String]
      # @return [Array<Subber::Subtitle>]
      #
      def parse(content)
        content = remove_window_line_break(content)
        subtitle_texts = content.split(DELIMITER_REGEX)

        subtitle_texts.map do |subtitle_text|
          subtitle_map = convert_text_to_map(subtitle_text)
          convert_map_to_subtitle(subtitle_map)
        end
      end

      private

      # @param text [String]
      # @return [String]
      #
      def remove_window_line_break(text)
        text.gsub(WINDOW_LINE_BREAK_REGEX, '')
      end

      # @param subtitle_text [String]
      # @return [Hash]
      #
      def convert_text_to_map(subtitle_text)
        matches = subtitle_text.match(SUBTITLE_REGEX).to_a
        raise(Subber::Errors::InvalidSrtFormat, subtitle_text) if matches.empty?

        _subtitle_text, counter, time_range_string, _new_line, content = matches

        counter = extract_counter(counter)
        from, to = extract_time_range(time_range_string)

        {
          counter: counter,
          start_time: convert_time_to_ms(from),
          end_time: convert_time_to_ms(to),
          content: content.to_s
        }
      rescue Subber::Errors::InvalidCounter
        raise(Subber::Errors::InvalidCounter, subtitle_text)
      rescue Subber::Errors::InvalidTimeRange
        raise(Subber::Errors::InvalidTimeRange, subtitle_text)
      rescue Subber::Errors::InvalidTimestamp
        raise(Subber::Errors::InvalidTimestamp, subtitle_text)
      end

      # @param [Hash] subtitle_map
      # @param counter [String]
      # @param start_time [String]
      # @param end_time [String]
      # @param content [String]
      #
      def convert_map_to_subtitle(subtitle_map)
        Subber::Subtitle.new(
          counter: subtitle_map[:counter],
          start_time: subtitle_map[:start_time],
          end_time: subtitle_map[:end_time],
          content: subtitle_map[:content]
        )
      end

      # @param  counter_string [String]
      # @return [Integer]
      # @raise  [Subber::Errors::InvalidCounter]
      #
      def extract_counter(text)
        raise(Subber::Errors::InvalidCounter) if text.match(COUNTER_REGEX).nil?
        text.sub!(BYTE_ORDER_MARK_STRING, '')
        text.to_i
      end

      # @param  text [String]
      # @return [
      #   [String] from
      #   [String] to
      # ]
      # @raise [Subber::Errors::InvalidCounter]
      #
      def extract_time_range(text)
        matches = text.match(TIME_RANGE_REGEX).to_a
        raise(Subber::Errors::InvalidTimeRange) if matches.empty?
        _text, from, to = matches

        [from, to]
      end

      # @param  time_string [String]
      # @return [Integer]
      # @raise  [Subber::Errors::InvalidTimestamp]
      #
      def convert_time_to_ms(time_string)
        matches = time_string.match(TIMECODE_REGEX).to_a
        raise(Subber::Errors::InvalidTimestamp, time_string) if matches.empty?

        int_matches = matches.map(&:to_i)
        _time_string, hours, minutes, seconds, milliseconds = int_matches

        ((hours * 60 + minutes) * 60 + seconds) * 1000 + milliseconds
      end
    end
  end
end
