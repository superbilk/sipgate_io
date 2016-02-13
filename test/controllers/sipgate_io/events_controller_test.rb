require 'test_helper'

module SipgateIo
  class EventsControllerTest < ActionController::TestCase

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

    test "a valid answer" do
      post :create, { event: "answer",
                     callId: "55555",
                     user: ["Bob"]
                   }
      assert_response :success
    end

    test "an invalid answer" do
      post :create, { event: "answer",
                     callId: "55555"
                   }
      assert_response :error
    end

    test "a valid dtmf" do
      post :create, { event: "dtmf",
                     callId: "55555",
                     dtmf: "1234"
                   }
      assert_response :success
    end

    test "an invalid dtmf" do
      post :create, { event: "dtmf",
                     callId: "55555",
                     dtmf: "1234abc"
                   }
      assert_response :error
    end

    test "a valid hangup" do
      post :create, { event: "hangup",
                     callId: "55555",
                     cause: "normalClearing"
                   }
      assert_response :success
    end

    test "an invalid hangup" do
      post :create, { event: "hangup",
                     callId: "55555",
                     cause: "idk"
                   }
      assert_response :error
    end
  end
end
