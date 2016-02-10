module SipgateIo
  class EventController < ApplicationController
    skip_before_action :verify_authenticity_token

    def handle
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
      puts "#" * 40
      puts "Debug: #{event.inspect}"
      # puts "Valid? #{new_call.valid?}"
      puts "#" * 40
      head :ok
    end
  end
end
