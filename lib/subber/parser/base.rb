module Subber::Parser
  class Base
    attr_reader :raw_content

    class << self
      # @param content [String]
      # @return [Array<Subber::Subtitle>]
      #
      def parse(content)
        raise NotImplementedError
      end
    end
  end
end
