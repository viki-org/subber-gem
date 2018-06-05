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
end
