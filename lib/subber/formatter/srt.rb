module Subber::Formatter
  class Srt < Base
    class << self
      # @param subtitles [Array<Subber::Subtitle>]
      # @return [String]
      #
      def format(subtitles)
        srt_subtitle_texts =
          subtitles.map do |subtitle|
            convert_subtitle_to_srt_subtitle_text(subtitle)
          end

        srt_subtitle_texts.join("\n\n")
      end

      private

      # @param subtitle [Subber::Subtitle]
      # @return [String]
      #
      def convert_subtitle_to_srt_subtitle_text(subtitle)
        start_time = convert_ms_time_to_srt_time(subtitle.start_time)
        end_time = convert_ms_time_to_srt_time(subtitle.end_time)

        [
          "#{subtitle.counter}",
          "#{start_time} --> #{end_time}",
          "#{subtitle.content}",
        ].join("\n")
      end

      # @param ms_time [Integer] Time in milliseconds
      # @return [String] Formatted time
      #
      def convert_ms_time_to_srt_time(ms_time)
        seconds = ms_time / 1000.0
        Time.at(seconds).utc.strftime("%H:%M:%S,%L")
      end
    end
  end
end
