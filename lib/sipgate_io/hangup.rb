module SipgateIo
  class Hangup
    include ActiveModel::Validations
    include SipgateIo::EventProcessor

    attr_reader :event, :call_id, :cause

    validates :event, :call_id, :cause, presence: true
    validates :cause, inclusion: { in: %w(normalClearing busy cancel noAnswer congestion notFound) }
    validates :event, inclusion: { in: %w(hangup) }

    def initialize(params)
      @event = params[:event]
      @call_id = params[:callId]
      @cause = params[:cause]
    end
  end
end
