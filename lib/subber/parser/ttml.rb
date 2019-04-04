require 'nokogiri'

module Subber::Parser
  class Ttml < Base
    attr_reader :raw_content

    CUE_CSS_PATH = 'body'.freeze

    class << self
      # @param  content [String]
      # @return [Array<Subber::Subtitle>]
      #
      def parse(content)
        doc = Nokogiri::XML(content)

        cue_elements = doc.css('body > div, body > p')

        cue_elements.each_with_index.map do |cue_element, index|
          counter = index + 1
          convert_xml_element_to_subtitle(cue_element, counter)
        end
      end

      private

      # @param  element [Nokogiri::XML::Element]
      # @param  counter [Integer] sequence number
      # @return [Subber::Subtitle]
      #
      def convert_xml_element_to_subtitle(element, counter)
        begin_str = element.attribute('begin').value
        end_str = element.attribute('end').value
        content = element.text.strip

        start_time = parse_milisecond(begin_str)
        end_time = parse_milisecond(end_str)

        Subber::Subtitle.new(
          counter: counter,
          start_time: start_time,
          end_time: end_time,
          content: content
        )
      end

      # @param  time_string [String] e.g. 100ms, 5s
      # @return [Integer] duration in milisecond
      #
      def parse_milisecond(time_string)
        regex = /(\d+)(\w+)/
        match_data = time_string.match(regex)

        message = "#{time_string} is not a valid timestamp"

        raise(Subber::Errors::InvalidTimestamp, message) unless match_data

        _time_string, number, unit = match_data.to_a

        case unit
        when 's'
          number.to_i * 1000
        when 'ms'
          number.to_i
        else
          raise(Subber::Errors::InvalidTimestamp, message)
        end
      end
    end
  end
end
