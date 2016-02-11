require "rails/engine"
require "sipgate_io/version"
require "sipgate_io/new_call"
require "sipgate_io/answer"
require "sipgate_io/dtmf"
require "sipgate_io/hangup"
require "sipgate_io/configuration"
require "sipgate_io/xml_response"

module SipgateIo
  class Engine < Rails::Engine; end
  # Your code goes here...
end
