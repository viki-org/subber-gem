module Subber::Parser
  class Vtt < Base
    SUBTITLE_REGEX = /(\d*)\n?(^\d{0,2}:?\d{2}:\d{2}\.\d{3}\s-->\s\d{0,2}:?\d{2}:\d{2}\.\d{3}$)\n?(.*)/m
    COUNTER_REGEX = /\d+/
    TIME_RANGE_REGEX = /(^\d{0,2}:?\d{2}:\d{2}\.\d{3})\s-->\s(\d{0,2}:?\d{2}:\d{2}\.\d{3}$)/
    TIMECODE_REGEX = /(^\d{0,2}):?(\d{2}):(\d{2})\.(\d{3})/

    CUE_DELIMITER_REGEX = /\n\n/
    WINDOW_LINE_BREAK_REGEX = /\r/
    BYTE_ORDER_MARK_STRING = "\xEF\xBB\xBF".freeze
    INVALID_CUE_START_STRINGS = %w[WEBVTT NOTE STYLE REGION].freeze

    class << self
      # @param file_content [String]
      # @return [Array<Subber::Subtitle>]
      #
      def parse(file_content)
        file_content = remove_window_line_break(file_content)
        cues = extract_cues(file_content)

        cues.map.with_index do |cue, index|
          convert_cue_to_subtitle(cue, index)
        end
      end

      private

      # @param file_content [String]
      # @return [Array<String>]
      #
      def extract_cues(file_content)
        cues = file_content.split(CUE_DELIMITER_REGEX)
        cues.reject do |cue|
          cue.start_with?(*INVALID_CUE_START_STRINGS)
        end
      end

      # @param cue [String]
      # @param index [Integer]
      # @return [Array<Subber::Subtitle>]
      #
      def convert_cue_to_subtitle(cue, index)
        matches = cue.match(SUBTITLE_REGEX).to_a
        raise(Subber::Errors::InvalidVttFormat, cue) if matches.empty?

        _cue, counter, time_range_string, content = matches

        counter = (index + 1).to_s if counter.empty?

        counter = extract_counter(counter)
        from, to = extract_time_range(time_range_string)

        Subber::Subtitle.new(
          counter: counter,
          start_time: convert_time_to_ms(from),
          end_time: convert_time_to_ms(to),
          content: content.strip
        )
      rescue Subber::Errors::InvalidCounter
        raise(Subber::Errors::InvalidCounter, cue)
      rescue Subber::Errors::InvalidTimeRange
        raise(Subber::Errors::InvalidTimeRange, cue)
      rescue Subber::Errors::InvalidTimestamp
        raise(Subber::Errors::InvalidTimestamp, cue)
      end

      # @param file_content [String]
      # @return [String]
      #
      def remove_window_line_break(file_content)
        file_content.gsub(WINDOW_LINE_BREAK_REGEX, '')
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
