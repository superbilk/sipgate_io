module SipgateIo
  class NewCallController < ApplicationController
    skip_before_action :verify_authenticity_token

    def process_call
      new_call = Call.new(params)
      puts "#" * 40
      puts "processing..."
      puts "Debug:"
      puts new_call.inspect
      puts "#" * 40
      head :ok
    end
  end
end
