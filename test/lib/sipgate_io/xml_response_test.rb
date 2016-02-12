require 'test_helper'

module SipgateIo
  class XmlResponseTestTest < ActiveSupport::TestCase

    test "hangup xml response without parameter" do
      actual = SipgateIo::XmlResponse.hangup
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Hangup/></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "hangup xml response with on_answer parameter" do
      actual = SipgateIo::XmlResponse.hangup(callback: :on_answer)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onAnswer="http://localhost:3000"><Hangup/></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "hangup xml response with on_hangup parameter" do
      actual = SipgateIo::XmlResponse.hangup(callback: :on_hangup)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onHangup="http://localhost:3000"><Hangup/></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "reject without reason" do
      actual = SipgateIo::XmlResponse.reject
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Reject/></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "reject with reason" do
      actual = SipgateIo::XmlResponse.reject(reason: :busy)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Reject reason="busy"/></Response>]
      assert_equal sanitize_xml_for_test(actual), expected

      actual = SipgateIo::XmlResponse.reject(reason: :rejected)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Reject reason="rejected"/></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "reject with reason and callback" do
      actual = SipgateIo::XmlResponse.reject(reason: :busy, callback: :on_hangup)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onHangup="http://localhost:3000"><Reject reason="busy"/></Response>]
      assert_equal sanitize_xml_for_test(actual), expected

      actual = SipgateIo::XmlResponse.reject(reason: :rejected, callback: :on_answer)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onAnswer="http://localhost:3000"><Reject reason="rejected"/></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "play with url" do
      actual = SipgateIo::XmlResponse.play(soundfile_url: "http://file.wav")
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Play><Url>http://file.wav</Url></Play></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "play with url and callback" do
      actual = SipgateIo::XmlResponse.play(soundfile_url: "http://file.wav", callback: :on_hangup)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onHangup="http://localhost:3000"><Play><Url>http://file.wav</Url></Play></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "gather xml response without parameter" do
      actual = SipgateIo::XmlResponse.gather
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Gather onData="http://localhost:3000"></Gather></Response>]
      assert_equal sanitize_xml_for_test(actual), expected

      actual = SipgateIo::XmlResponse.gather()
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Gather onData="http://localhost:3000"></Gather></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "gather xml response with callback" do
      actual = SipgateIo::XmlResponse.gather(callback: :on_hangup)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onHangup="http://localhost:3000"><Gather onData="http://localhost:3000"></Gather></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "gather xml response with parameter" do
      actual = SipgateIo::XmlResponse.gather(soundfile_url: "http://file.wav")
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Gather onData="http://localhost:3000"><Play><Url>http://file.wav</Url></Play></Gather></Response>]
      assert_equal sanitize_xml_for_test(actual), expected

      actual = SipgateIo::XmlResponse.gather(soundfile_url: "http://file.wav", timeout: 5000)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Gather onData="http://localhost:3000" timeout="5000"><Play><Url>http://file.wav</Url></Play></Gather></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "gather xml response with parameter and callback" do
      actual = SipgateIo::XmlResponse.gather(soundfile_url: "http://file.wav", callback: :on_hangup)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onHangup="http://localhost:3000"><Gather onData="http://localhost:3000"><Play><Url>http://file.wav</Url></Play></Gather></Response>]
      assert_equal sanitize_xml_for_test(actual), expected

      actual = SipgateIo::XmlResponse.gather(soundfile_url: "http://file.wav", max_digits: 5, callback: :on_answer)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onAnswer="http://localhost:3000"><Gather onData="http://localhost:3000" maxDigits="5"><Play><Url>http://file.wav</Url></Play></Gather></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "call redirect to voicemail" do
      actual = SipgateIo::XmlResponse.dial(target: :voicemail)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Dial><Voicemail/></Dial></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "call redirect to number" do
      actual = SipgateIo::XmlResponse.dial(target: "4915799912345")
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Dial><Number>4915799912345</Number></Dial></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "call redirect to number with anonymous" do
      actual = SipgateIo::XmlResponse.dial(target: "4915799912345", clip: :anonymous)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Dial anonymous="true"><Number>4915799912345</Number></Dial></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "call redirect to number with clip" do
      actual = SipgateIo::XmlResponse.dial(target: "4915799912345", clip: "4915799912345")
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response><Dial callerId="4915799912345"><Number>4915799912345</Number></Dial></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "call redirect to number with clip and callback" do
      actual = SipgateIo::XmlResponse.dial(target: "4915799912345", clip: "4915799912345", callback: :on_answer)
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onAnswer="http://localhost:3000"><Dial callerId="4915799912345"><Number>4915799912345</Number></Dial></Response>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "only on answer" do
      actual = SipgateIo::XmlResponse.on_answer
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onAnswer="http://localhost:3000"/>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    test "only on hangup" do
      actual = SipgateIo::XmlResponse.on_hangup
      expected = %Q[<?xml version="1.0" encoding="UTF-8"?><Response onHangup="http://localhost:3000"/>]
      assert_equal sanitize_xml_for_test(actual), expected
    end

    private

    def sanitize_xml_for_test(xml)
      xml.gsub(/(?<=\s{1})\s+/,"").gsub("\n", "")
    end
  end
end
