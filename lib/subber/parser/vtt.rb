module Subber::Parser
  class Vtt < Base
    SUBTITLE_REGEX = /([^\n]*)\n([^\n]*)(\n(.*))?/m
    COUNTER_REGEX = /\d+/
    TIME_RANGE_REGEX = /(\d{2}:\d{2}:\d{2}\.\d{3})\s*-->\s*(\d{2}:\d{2}:\d{2}\.\d{3})/
    TIMECODE_REGEX = /(\d{2}):(\d{2}):(\d{2})\.(\d{3})/

    DELIMITER_REGEX = /\n?\n\n/
    WINDOW_LINE_BREAK_REGEX = /\r/
    WEBVTT_HEADER_REGEX = /WEBVTT\n\n/
    BYTE_ORDER_MARK_STRING = "\xEF\xBB\xBF"

    class << self
      # @param file_content [String]
      # @return [Array<Subber::Subtitle>]
      #
      def parse(file_content)
        file_content = remove_window_line_break(file_content)
        file_content = remove_webvtt_header(file_content)

        subtitle_texts = file_content.split(DELIMITER_REGEX)
        subtitle_texts.map do |subtitle_text|
          convert_text_to_subtitle(subtitle_text)
        end
      end

      private

      # @param file_content [String]
      # @return [String]
      #
      def remove_webvtt_header(file_content)
        file_content.sub(WEBVTT_HEADER_REGEX, '')
      end

      # @param file_content [String]
      # @return [String]
      #
      def remove_window_line_break(file_content)
        file_content.gsub(WINDOW_LINE_BREAK_REGEX, '')
      end

      # @param subtitle_text [String]
      # @return [Subber::Subtitle]
      #
      def convert_text_to_subtitle(subtitle_text)
        matches = subtitle_text.match(SUBTITLE_REGEX).to_a
        raise(Subber::Errors::InvalidSrtFormat, subtitle_text) if matches.empty?

        _subtitle_text, counter, time_range_string, _new_line, content = matches

        counter = extract_counter(counter)
        from, to = extract_time_range(time_range_string)

        Subber::Subtitle.new(
          counter: counter,
          start_time: convert_time_to_ms(from),
          end_time: convert_time_to_ms(to),
          content: content
        )
      rescue Subber::Errors::InvalidCounter
        raise(Subber::Errors::InvalidCounter, subtitle_text)
      rescue Subber::Errors::InvalidTimeRange
        raise(Subber::Errors::InvalidTimeRange, subtitle_text)
      rescue Subber::Errors::InvalidTimestamp
        raise(Subber::Errors::InvalidTimestamp, subtitle_text)
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
