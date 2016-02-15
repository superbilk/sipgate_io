module SipgateIo
  class NewCall
    include ActiveModel::Validations
    include SipgateIo::EventProcessor

    attr_reader :to, :from, :direction, :event, :call_id, :users, :diversion

    validates :to, :from, :direction, :event, :call_id, :users, presence: true
    validates :direction, inclusion: { in: %w(in out) }
    validates :event, inclusion: { in: %w(newCall) }
    validates :to, :from, format: { with: /\A\+?[1-9]\d{1,14}\z|\Aanonymous\z/ }

    def initialize(params)
      @to = params[:to]
      @from = params[:from]
      @direction = params[:direction]
      @event = params[:event]
      @call_id = params[:callId]
      @users = params[:user]
      @diversion = params[:diversion] unless params[:diversion].blank?
    end

  end
end
