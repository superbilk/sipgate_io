class EventProcessor
  def initialize(event)
    @event = event
  end

  def process
    return SipgateIo::XmlResponse.reject
  end
end
