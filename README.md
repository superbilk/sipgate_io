sipgate.io
========

sipgate.io is sipgate's new Push-API. With sipgate.io booked, we send you call meta data every time someone calls. And when someone picks up. And when someone hangs up. 

### Receive realtime call meta data in your Rails app

This gem is a Rails engine that provides an endpoint for sipgate.io that parses these API POSTs and hands off a
built event object to a class implemented by you.

Tutorials
---------

* tba

Installation
------------

1. Add `sipgate_io` gem to your application's Gemfile
   and run `bundle install`.

2. A route is needed for the endpoint which receives `POST` messages. To add the
   route, in `config/routes.rb` you may either use the provided routing method
   `mount_griddler` or set the route explicitly. Examples:

   ```ruby
   # config/routes.rb

   # mount using default path: /email_processor
   mount_griddler

   # mount using a custom path
   mount_griddler('/email/incoming')

   # the DIY approach:
   post '/email_processor' => 'griddler/emails#create'
   ```

### Configuration Options

An initializer can be created to control some of the options in sipgate.io.
Defaults are shown below with sample overrides following. In
`config/initializers/sipgate.io.rb`:

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
initialized with a `SipgateIo::Event` instance representing the event, and has a `process` method to actually process the event.
For example, in `./lib/event_processor.rb`:

```ruby
class EventProcessor
  def initialize(event)
    @event = event
  end

  def process
    # all of your application-specific code here - creating models,
    # processing reports, etc

    # here's an example of model creation
    user = User.find_by_email(@email.from[:email])
    user.posts.create!(
      subject: @email.subject,
      body: @email.body
    )
  end
end
```

Griddler::Email attributes
--------------------------

| Attribute      | Description
| -------------- | -----------
| `#to`          | An array of hashes containing recipient address information.  See [Email Addresses](#email-addresses) for more information.
| `#from`        | A hash containing the sender address information.
| `#cc`          | An array of hashes containing cc email address information.
| `#subject`     | The subject of the email message.
| `#body`        | The full contents of the email body **unless** there is a line in the email containing the string `-- REPLY ABOVE THIS LINE --`. In that case `.body` will contain everything before that line.
| `#raw_text`    | The raw text part of the body.
| `#raw_html`    | The raw html part of the body.
| `#raw_body`    | The raw body information provided by the email service.
| `#attachments` | An array of `File` objects containing any attachments.
| `#headers`     | A hash of headers parsed by `Mail::Header`, unless they are already formatted as a hash when received from the adapter in which case the original hash is returned.
| `#raw_headers` | The raw headers included in the message.

### Email Addresses

Gridder::Email provides email addresses as hashes. Each hash will have the following
information of each recipient:

| Key | Value
| --- | -----
| `:token` | All the text before the email's "@". We've found that this is the most often used portion of the email address and consider it to be the token we'll key off of for interaction with our application.
| `:host` | All the text after the email's "@". This is important to filter the recipients sent to the application vs emails to other domains. More info below on the Upgrading to 0.5.0 section.
| `:email` | The email address of the recipient.
| `:full` | The whole recipient field (e.g., `Some User <hello@example.com>`).
| `:name` | The name of the recipient (e.g., `Some User`).

Testing In Your App
-------------------

You may want to create a factory for when testing the integration of Griddler
into your application. If you're using factory\_girl this can be accomplished
with the following sample factory:

```ruby
factory :email, class: OpenStruct do
  # Assumes Griddler.configure.to is :hash (default)
  to [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }]
  from({ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'From User <from_user@email.com>', name: 'From User' })
  subject 'email subject'
  body 'Hello!'
  attachments {[]}

  trait :with_attachment do
    attachments {[
      ActionDispatch::Http::UploadedFile.new({
        filename: 'img.png',
        type: 'image/png',
        tempfile: File.new("#{File.expand_path(File.dirname(__FILE__))}/fixtures/img.png")
      })
    ]}
  end
end
```

Bear in mind, if you plan on using the `:with_attachment` trait, that this
example assumes your factories are in `spec/factories.rb` and you have
an image file in `spec/fixtures/`.

To use it in your tests, build with `email = build(:email)`
or `email = build(:email, :with_attachment)`.



Credits
-------

Griddler was written by Caleb Thompson and Joel Oliveira.

Thanks to our [contributors](https://github.com/thoughtbot/griddler/contributors)!

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

The names and logos for thoughtbot are trademarks of thoughtbot, inc.
