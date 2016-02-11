class EventProcessor
  def initialize(event)
    @event = event
  end

  def process
    puts "#" * 40
    puts "EventProcessor"
    puts @event.inspect
    puts "#" * 40
    return SipgateIo::XmlResponse.reject
  end
end
