module SipgateIo
  class NewCallController < ApplicationController
    skip_before_action :verify_authenticity_token

    def process_call
      puts "#" * 40
      puts "processing..."
      puts "#" * 40
      head :ok
    end
  end
end
