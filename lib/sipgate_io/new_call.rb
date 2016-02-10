module SipgateIo
  class NewCall
    attr_reader :to, :from, :direction, :event, :call_id, :users, :diversion

    def initialize(params)
      @to = params[:to]
      @from = params[:from]
      @direction = params[:direction]
      @event = params[:event]
      @call_id = params[:callId]
      @users = params[:user]
      @diversion = params[:diversion] unless params[:diversion].blank?
    end

    private

    def valid_number(number)
      return true if number =~ /^\+?[1-9]\d{1,14}$|^anonymous$/
    end
  end
end
