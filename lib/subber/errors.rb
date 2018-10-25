class Subber::Errors
  class InvalidVttFormat < RuntimeError; end
  class InvalidSrtFormat < RuntimeError; end
  class InvalidCounter < RuntimeError; end
  class InvalidTimeRange < RuntimeError; end
  class InvalidTimestamp < RuntimeError; end
end
