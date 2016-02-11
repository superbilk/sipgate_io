module SipgateIo
  class Dtmf
    include ActiveModel::Validations

    attr_reader :event, :call_id, :dtmf

    def initialize(params)
      @event = params[:event]
      @call_id = params[:callId]
      @dtmf = params[:dtmf]
    end
  end
end
