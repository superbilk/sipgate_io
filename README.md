# SipgateIo

This project rocks and uses MIT-LICENSE.

### sipgate says:

> sipgate.io is sipgate's new Push-API. With sipgate.io booked, we send you call meta data every time someone calls. And when someone picks up. And when someone hangs up.

## Receive realtime call meta data in your Rails app

This gem is a Rails engine that provides an endpoint for sipgate.io that parses these Push-API POSTs and hands off a
built event object to a class implemented by you.

## Tutorials

* tba

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

## Configuration Options

An initializer can be created to control some of the options in sipgate_io.
Defaults are shown below with sample overrides following. In
`config/initializers/sipgate_io.rb`:

```ruby
SipgateIo.configure do |config|
  config.processor_class = EventProcessor # CountMyCalls
  config.processor_method = :process # :add_call (A method on CountMyCalls)
end
```

| Option             | Meaning
| ------             | -------
| `processor_class`  | The class sipgate.io will use to handle your incoming events.
| `processor_method` | The method sipgate.io will call on the processor class when handling your incoming events.

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
  end
end
```

Keep in mind, that Rails does NOT autloload files in `lib`. You can conveniently put tis file in `controllers` or `models` - there it is autoloaded.



## Testing In Your App

* tba


## Credits

Most of the code is copied fom Griddler by Caleb Thompson and Joel Oliveira / thoughtbot.
You find the code [here](https://github.com/thoughtbot/griddler)
