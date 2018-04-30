module Subber::Exporter
  class Vtt < Base
    def content
      vtt_subtitle_texts =
        subtitles.map do |subtitle|
          convert_subtitle_to_vtt_subtitle_text(subtitle)
        end

      "WEBVTT\n\n#{vtt_subtitle_texts.join("\n\n")}"
    end

    private

    def convert_subtitle_to_vtt_subtitle_text(subtitle)
      start_time = convert_ms_time_to_vtt_time(subtitle.start_time)
      end_time = convert_ms_time_to_vtt_time(subtitle.end_time)

      [
        "#{subtitle.counter}",
        "#{start_time} --> #{end_time}",
        "#{subtitle.content}",
      ].join("\n")
    end

    def convert_ms_time_to_vtt_time(ms_time)
      seconds = ms_time / 1000.0
      Time.at(seconds).utc.strftime("%H:%M:%S.%L")
    end
  end
end
