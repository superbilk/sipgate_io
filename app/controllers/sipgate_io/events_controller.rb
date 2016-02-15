require_dependency "sipgate_io/application_controller"

module SipgateIo
  class EventsController < ApplicationController
    skip_before_action :verify_authenticity_token, raise: false

    def create
      (head 500 and return) unless params.key?(:event)

      event = create_event(params)

      (head 500 and return) if event.invalid?


      answer = event.process
      render xml: answer
    end

    private

    def create_event(params)
      event_type = params[:event].clone
      event_type[0] = event_type[0].upcase
      "SipgateIo::#{event_type}".constantize.new(params)
    end

  end
end
