require 'test_helper'

module SipgateIo
  class EventsControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "create without params gives 500" do
      get :create
      assert_response :error
    end

  end
end
