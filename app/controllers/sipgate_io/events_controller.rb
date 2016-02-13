require_dependency "sipgate_io/application_controller"

module SipgateIo
  class EventsController < ApplicationController
    skip_before_action :verify_authenticity_token, raise: false

    def create
      (head 500 and return) unless params.key?(:event)

      event = create_event_object(params)

      (head 500 and return) if event.invalid?

      answer = process_event event
      render xml: answer
    end

    private

    delegate :processor_class, :processor_method, to: :sipgate_io_configuration

    def create_event_object(params)
      event_type = params[:event].clone
      event_type[0] = event_type[0].upcase
      "SipgateIo::#{event_type}".constantize.new(params)
    end

    def process_event(event)
      processor_class.new(event).public_send(processor_method)
    end

    def sipgate_io_configuration
      SipgateIo.configuration
    end
  end
end
