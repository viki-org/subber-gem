require 'nokogiri'

module Subber::Parser
  class Ttml < Base
    attr_reader :raw_content

    class << self
      # @param content [String]
      # @return [Array<Subber::Subtitle>]
      #
      def parse(_content)
        raise NotImplementedError
      end
    end
  end
end
