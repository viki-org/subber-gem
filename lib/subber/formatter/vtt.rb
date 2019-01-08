module Subber::Formatter
  class Vtt < Base
    LF_REGEX = /\n/
    CRLF = "\r\n".freeze

    class << self
      # @param subtitles [Array<Subber::Subtitle>]
      # @return [String]
      #
      def format(subtitles)
        cues =
          subtitles.map do |subtitle|
            convert_subtitle_to_cue(subtitle)
          end

        file_content = cues.join
        file_content = add_webvtt_header(file_content)
        file_content = add_window_line_break(file_content)
        file_content
      end

      private

      # @param file_content [String]
      # @return [String]
      #
      def add_webvtt_header(file_content)
        "WEBVTT\n\n#{file_content}"
      end

      # @param file_content [String]
      # @return [String]
      #
      def add_window_line_break(file_content)
        file_content.gsub(LF_REGEX, CRLF)
      end

      # @param subtitle [Subber::Subtitle]
      # @return [String]
      #
      def convert_subtitle_to_cue(subtitle)
        cue = [
          build_counter(subtitle),
          build_time_range(subtitle),
          build_content(subtitle)
        ].join("\n")

        "#{cue}\n\n"
      end

      # @param subtitle [Subber::Subtitle]
      # @return [String]
      #
      def build_counter(subtitle)
        subtitle.counter.to_s
      end

      # @param subtitle [Subber::Subtitle]
      # @return [String]
      #
      def build_time_range(subtitle)
        start_time = convert_ms_to_time(subtitle.start_time)
        end_time = convert_ms_to_time(subtitle.end_time)

        "#{start_time} --> #{end_time}"
      end

      # @param subtitle [Subber::Subtitle]
      # @return [String]
      #
      def build_content(subtitle)
        subtitle.content
      end

      # @param ms_time [Integer] Time in milliseconds
      # @return [String] Formatted time
      #
      def convert_ms_to_time(ms_time)
        seconds = ms_time / 1000.0
        formatted_seconds_str = Time.at(seconds).utc.strftime('%H:%M:%S')

        # fix float precision
        #
        ms = ms_time % 1000
        formatted_ms_str = ms.to_s.rjust(3, '0')

        "#{formatted_seconds_str}.#{formatted_ms_str}"
      end
    end
  end
end
