module Subber::Errors
  class Base < RuntimeError; end

  class InvalidContent < Base; end

  class InvalidVttFormat < InvalidContent; end
  class InvalidSrtFormat < InvalidContent; end
  class InvalidJsonFormat < InvalidContent; end

  class InvalidCounter < InvalidContent; end
  class InvalidTimeRange < InvalidContent; end
  class InvalidTimestamp < InvalidContent; end

  class NotSupported < Base; end
end
