require 'test_helper'

class SipgateIo::NewCallTest < Minitest::Test
  def setup
    @call = SipgateIo::NewCall.new(from: "491234567",
                                   to: "497654321",
                                   direction: "in",
                                   event: "newCall",
                                   user: ["Adam", "Bob"],
                                   callId: "1234")
  end

  def test_it_does_something_useful
    assert true
  end

  def test_numbercheck
    assert @call.send(:valid_number, @call.from)
    assert @call.send(:valid_number, "anonymous")
    assert !@call.send(:valid_number, "")
  end
end
