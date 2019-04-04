require 'nokogiri'

# Timed Text Markup Language 1
#
module Subber::Formatter
  class Ttml < Base
    XML_NAMESPACE = 'http://www.w3.org/ns/ttml'

    class << self
      # @param  subtitles [Array<Subber::Subtitle>]
      # @return [String]
      #
      def format(subtitles)
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.tt(xmlns: XML_NAMESPACE) do
            xml.body do
              subtitles.each do |subtitle|
                generate_subtitle_cue(subtitle, insert_into: xml)
              end
            end
          end
        end

        builder.to_xml
      end

      private

      # @param  subtitle [Subber::Subtitle]
      # @param  insert_into [Nokogiri::XML::Builder]
      #
      def generate_subtitle_cue(subtitle, insert_into: nil)
        xml = insert_into

        begin_str = format_milisecond(subtitle.start_time)
        end_str = format_milisecond(subtitle.end_time)

        xml.div(begin: begin_str, end: end_str) do
          xml.p do
            xml.text subtitle.content
          end
        end

        nil
      end

      # @param  ms_duration [Integer] Time duration in milisecond
      # @return [String] "1000ms"
      #
      def format_milisecond(ms_duration)
        "#{ms_duration}ms"
      end
    end
  end
end
