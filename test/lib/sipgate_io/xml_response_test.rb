require 'test_helper'

module SipgateIo
  class XmlResponseTestTest < ActiveSupport::TestCase

    test "hangup xml response without parameter" do
      actual = SipgateIo::XmlResponse.hangup
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Hangup/></Response>]

      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "hangup xml response with on_answer parameter" do
      actual = SipgateIo::XmlResponse.hangup(on_answer: "http://google.de")
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onAnswer="http://google.de"><Hangup/></Response>]

      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "hangup xml response with on_hangup parameter" do
      actual = SipgateIo::XmlResponse.hangup(on_hangup: "http://google.de")
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onHangup="http://google.de"><Hangup/></Response>]

      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "hangup xml response with invalid parameter" do
      actual = SipgateIo::XmlResponse.hangup(foo: "bar")
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Hangup/></Response>]

      assert_equal sanitize_xml_for_test(actual), expected
    end

    private

    def sanitize_xml_for_test(xml)
      xml.gsub(/(?<=\s{1})\s+/,"").gsub("\n", "")
    end
  end
end
