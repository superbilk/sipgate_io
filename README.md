# gem "sipgate_io"

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

## Installation

1. Add `sipgate_io` gem to your application's Gemfile
   and run `bundle install`.

   This gem is not on RubyGems yet, so please use
   `gem 'sipgate_io', :git => 'git://github.com/superbilk/sipgate_io.git'`

2. A route is needed for the endpoint which receives `POST` messages. To add the
   route, in `config/routes.rb`please mount the route explicitly. Example:

   ```ruby
   # config/routes.rb

   # the full route will be '/sipgate_io/events/create'
   mount SipgateIo::Engine => "/sipgate_io"
   ```

### Configuration Options

An initializer can be created to control some of the options in sipgate_io.
Defaults are shown below with sample overrides following. In
`config/initializers/sipgate_io.rb`:

```ruby
SipgateIo.configure do |config|
  config.processor_class = EventProcessor # CountMyCalls
  config.processor_method = :process # :add_call (A method on CountMyCalls)
  config.callback_url = "https://example.org/sipgate_io/events/create"
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
SipgateIo::XmlResponse.reject(:busy)
SipgateIo::XmlResponse.reject(:rejected)
SipgateIo::XmlResponse.hangup

# forward that call
SipgateIo::XmlResponse.dial(:voicemail)
SipgateIo::XmlResponse.dial("491234567")
SipgateIo::XmlResponse.dial("491234567", anonymous: true)
SipgateIo::XmlResponse.dial("491234567", caller_id: "555")

# play an announcement
SipgateIo::XmlResponse.play("http://some.wav")

# wait for DTMF
SipgateIo::XmlResponse.gather()
SipgateIo::XmlResponse.gather(play_url: "http://some.wav")
```

## Testing In Your App

* tba

## Credits

Most of the code is copied fom Griddler by Caleb Thompson and Joel Oliveira / thoughtbot.
You find the code [here](https://github.com/thoughtbot/griddler)
