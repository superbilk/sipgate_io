module SipgateIo
  class Answer
    attr_reader :event, :call_id, :user

    def initialize(params)
      @event = params[:event]
      @call_id = params[:callId]
      @user = params[:user]
    end
  end
end
