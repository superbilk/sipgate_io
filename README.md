# gem "sipgate_io"
[![Gem Version](https://badge.fury.io/rb/sipgate_io.svg)](https://badge.fury.io/rb/sipgate_io)
[![Build Status](https://travis-ci.org/superbilk/sipgate_io.svg?branch=master)](https://travis-ci.org/superbilk/sipgate_io)

This project rocks and uses MIT-LICENSE.

## Receive realtime call meta data in your Rails app

This gem is a Rails engine that provides an endpoint for sipgate.io that parses these Push-API POSTs and hands off a
built event object to a class implemented by you.

### sipgate says:

> sipgate.io is sipgate's new Push-API. With sipgate.io booked, we send you call meta data every time someone calls. And when someone picks up. And when someone hangs up.

### Requirement: Account with sipgate

You need an account and phonenumber with sipgate. A free sipgate basic account is sufficient.

* [x] [Create a free sipgate basic account](https://www.sipgate.de/go)
* [x] [Book the sipgate.io feature](https://www.sipgate.de/go/feature-store/sipgate.io)
* [x] [Enter an URL for incoming/outgoing calls in the dashboard](https://www.sipgate.de/go/dashboard)

### Have a working example in 5 Minutes

There is a fully working example app included in this gem.

* Have your sipgate account ready (you can create one in a minute, see above)
* You need [ngrok](https://ngrok.com/) to receive a POST from sipgate on your locale machine
* Clone this gem `git clone https://github.com/superbilk/sipgate_io.git` and cd into it `cd sipgate_io`
* Go to app root `cd test/dummy`
* Make sure all gems are installed `bundle install`
* Start rails app `rails s`
* Start ngrok in another terminal `ngrok http 3000` you get a secure forwarding URL like `https://999b1wa06.ngrok.io`
* Add your forwarding URL to your sipgate account, don't forget to add `/sipgate_io` (`https://999b1wa06.ngrok.io/sipgate_io`). Use the same URL for incoming & outgoing calls
* Make a phonecall and you will see the call in realtime in your console (the one with the rails server running)
* Change what happens with the call [`test/dummy/app/models/event_processor.rb`](https://github.com/superbilk/sipgate_io/blob/master/test/dummy/app/models/event_processor.rb)

You can also check out my complete Rails 5 (beta2) app with ActionCable with a sipgate.io proof of concept. It's  [callmonitor](https://github.com/superbilk/callmonitor) on github.

## Installation

1. Add `sipgate_io` gem to your application's Gemfile
   and run `bundle install`.

2. A route is needed for the endpoint which receives `POST` messages. To add the
   route, in `config/routes.rb` you may either use the provided routing method
   `mount_sipgate_io` or set the route explicitly. Examples:

   ```ruby
   # config/routes.rb

   # mount using default path: /sipgate_io
   mount_sipgate_io

   # mount using a custom path
   mount_sipgate_io('/call/push')

   # the DIY approach:
   post '/call_processor' => 'sipgate_io/events#create'
   ```

### Configuration Options

An initializer can be created to control some of the options in sipgate_io.
Defaults are shown below with sample overrides following. In
`config/initializers/sipgate_io.rb`:

```ruby
SipgateIo.configure do |config|
  config.processor_class = EventProcessor # CountMyCalls
  config.processor_method = :process # :add_call (A method on CountMyCalls)
  config.callback_url = "https://example.org/sipgate_io"
end
```

| Option             | Meaning
| ------             | -------
| `processor_class`  | The class sipgate.io will use to handle your incoming events.
| `processor_method` | The method sipgate.io will call on the processor class when handling your incoming events.
| `callback_url`     | Used for DTMF, on_answer and on_hangup.

By default sipgate.io will look for a class named `EventProcessor`. The class is
initialized with a event object representing the event, and has a `process` method to actually process the event.
For example, in `./lib/event_processor.rb`:

```ruby
class EventProcessor
  def initialize(event)
    @event = event
  end

  def process
    # all of your application-specific code here - creating models,
    # processing reports, etc
    return SipgateIo::XmlResponse.hangup
  end
end
```

Keep in mind, that Rails does NOT autoload files in `lib`. You can conveniently put tis file in `controllers` or `models` - there it is autoloaded.


## How to use it

You find the API documentation here: https://github.com/sipgate/sipgate.io

This gem makes the usage a bit more rubiesque. (call_id instead of callId, e.g.)

## Response helper

Your EventProcessor has to decide what to to with an event (hangup this call, forward it to voicemail, ...). You can build your own XML as shown in the sipgate documentation. To make your life easier, there are helper methods you can use.

Here are some examples:

```ruby
# don't answer that call
SipgateIo::XmlResponse.reject
SipgateIo::XmlResponse.reject(reason: :busy)
SipgateIo::XmlResponse.reject(reason: :rejected)
SipgateIo::XmlResponse.hangup

# forward that call
SipgateIo::XmlResponse.dial(target: :voicemail)
SipgateIo::XmlResponse.dial(target: "491234567", callback: :on_hangup)
SipgateIo::XmlResponse.dial(target: "491234567", clip: :anonymous)
SipgateIo::XmlResponse.dial(target: "491234567", clip: "555")

# play an announcement
SipgateIo::XmlResponse.play(soundfile_url: "http://some.wav", callback: :on_answer)

# wait for DTMF
SipgateIo::XmlResponse.gather()
SipgateIo::XmlResponse.gather(soundfile_url: "http://some.wav", timeout: 5000, callback: :on_hangup)
```

## Testing In Your App

* tba

## Credits

Most of the code is copied fom Griddler by Caleb Thompson and Joel Oliveira / thoughtbot.
You find the code [here](https://github.com/thoughtbot/griddler)
