module Subber::Exporter
  class Base
    attr_reader :subtitles

    def initialize(subtitles)
      @subtitles = subtitles
    end

    def content
      raise NotImplementedError
    end

    def export(destination)
      File.write(destination, content)
    end
  end
end
