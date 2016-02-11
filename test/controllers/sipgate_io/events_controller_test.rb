require 'test_helper'

module SipgateIo
  class EventsControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "create without params gives 500" do
      post :create
      assert_response :error
    end

    test "a new call" do
      post :create, { to: "12345",
                     from: "anonymous",
                     direction: "in",
                     event: "newCall",
                     callId: "55555",
                     user: ["Bob"]
                   }
      assert_response :success
    end

    test "a new call with missing to/from" do
      post :create, { direction: "in",
                     event: "newCall",
                     callId: "55555",
                     user: ["Bob"]
                   }
      assert_response :error
    end

    test "a new call with invalid to/from" do
      post :create, { to: "",
                     from: "peter",
                     direction: "in",
                     event: "newCall",
                     callId: "55555",
                     user: ["Bob"]
                   }
      assert_response :error
    end

  end
end
