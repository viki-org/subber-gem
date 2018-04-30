module Subber::Parser
  class Base
    attr_reader :raw_content

    def self.parse(raw_content)
      new(raw_content).parse
    end

    def initialize(raw_content)
      @raw_content = raw_content
    end

    def parse
      raise NotImplementedError
    end
  end
end
