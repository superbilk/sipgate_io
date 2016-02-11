require 'test_helper'

class SipgateIo::XmlResponseTest < Minitest::Test

  def test_hangup
#     expected_xml<<-eos
# <?xml version="1.0" encoding="UTF-8"?>
# <response>
#   <hangup/>
# </response>
#     eos
#     assert_equal expected_xml, SipgateIo::XmlResponse.hangup
  end
end

# puts SipgateIo::XmlResponse.dial(:voicemail)
# puts SipgateIo::XmlResponse.dial("491234567")
# puts SipgateIo::XmlResponse.dial("491234567", caller_id: "555")
# puts SipgateIo::XmlResponse.reject(:busy)
# puts SipgateIo::XmlResponse.reject
# puts SipgateIo::XmlResponse.reject(:busy)
# puts SipgateIo::XmlResponse.reject(:rejected)
# puts SipgateIo::XmlResponse.hangup
# puts SipgateIo::XmlResponse.hangup.class
# puts r.class
# puts r.kind_of? SipgateIo::XmlResponse
