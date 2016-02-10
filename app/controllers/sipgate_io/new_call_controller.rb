module SipgateIo
  class NewCallController < ApplicationController
    skip_before_action :verify_authenticity_token

    def process_call
      new_call = Call.new(params)
      puts "#" * 40
      puts "processing..."
      puts "Debug:"
      puts "Valid? #{new_call.valid?}"
      puts "#" * 40
      if new_call.valid?
        head :ok
      else
        head 500
      end
    end
  end
end
