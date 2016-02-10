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

  class Answer
    attr_reader :event, :call_id, :user

    def initialize(params)
      @event = params[:event]
      @call_id = params[:callId]
      @user = params[:user]
    end
  end

  class Hangup
    attr_reader :event, :call_id, :cause

    def initialize(params)
      @event = params[:event]
      @call_id = params[:callId]
      @cause = params[:cause]
    end
  end

  class Dtmf
    attr_reader :event, :call_id, :dtmf

    def initialize(params)
      @event = params[:event]
      @call_id = params[:callId]
      @dtmf = params[:dtmf]
    end
  end

end
