module Subber::File
  class << self
    def from_content(content, format)
      case format
      when 'srt'
        Subber::File::Srt.from_content(content)
      when 'vtt'
        Subber::File::Vtt.from_content(content)
      when 'json'
        Subber::File::Json.from_content(content)
      when 'ttml'
        Subber::File::Ttml.from_content(content)
      else
        message = "#{format} is not a supported source subtitle format"
        raise(Subber::Errors::NotSupported, message)
      end
    end
  end
end
