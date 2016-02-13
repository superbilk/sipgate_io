module SipgateIo
  class Dtmf
    include ActiveModel::Validations

    attr_reader :event, :call_id, :dtmf

    validates :event, :call_id, :dtmf, presence: true
    validates :event, inclusion: { in: %w(dtmf) }
    validates :dtmf, format: { with: /\A\d+\z/ }

    def initialize(params)
      @event = params[:event]
      @call_id = params[:callId]
      @dtmf = params[:dtmf]
    end
  end
end
