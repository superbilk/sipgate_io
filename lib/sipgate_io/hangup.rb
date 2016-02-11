module SipgateIo
  class Hangup
    include ActiveModel::Validations

    attr_reader :event, :call_id, :cause

    def initialize(params)
      @event = params[:event]
      @call_id = params[:callId]
      @cause = params[:cause]
    end
  end
end
