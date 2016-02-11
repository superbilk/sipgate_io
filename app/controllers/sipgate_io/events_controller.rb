module SipgateIo
  class EventsController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def create
      event_type = params[:event]
      case event_type
      when "newCall"
        event = NewCall.new(params)
      when "answer"
        event = Answer.new(params)
      when "hangup"
        event = Hangup.new(params)
      when "dtmf"
        event = Dtmf.new(params)
      else
        head 500
      end
      process_event event

      head :ok
    end

    private

    delegate :processor_class, :processor_method, to: :sipgate_io_configuration

    def process_event(event)
      processor_class.new(event).public_send(processor_method)
    end

    def sipgate_io_configuration
      SipgateIo.configuration
    end
  end
end
