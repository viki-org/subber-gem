class Subber::Subtitle
  attr_reader :counter
  attr_reader :start_time
  attr_reader :end_time
  attr_reader :content

  def initialize(attributes)
    @counter = attributes[:counter]
    @start_time = attributes[:start_time]
    @end_time = attributes[:end_time]
    @content = attributes[:content]
  end

  def as_json
    {
      'counter' => counter,
      'start_time' => start_time,
      'end_time' => end_time,
      'content' => content
    }
  end

  # @param miliseconds [Integer] Can be both positive and negative
  # @return [Subber::Subtitle] return a copy with shifted subtitle
  #
  def shifted(miliseconds)
    self.class.new(
      counter: counter,
      start_time: start_time + miliseconds,
      end_time: end_time + miliseconds,
      content: content
    )
  end
end
