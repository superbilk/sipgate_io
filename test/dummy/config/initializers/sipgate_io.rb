SipgateIo.configure do |config|
  config.processor_class = EventProcessor # CommentViaEmail
  config.processor_method = :process # :create_comment (A method on CommentViaEmail)
  config.callback_url = "http://localhost:3000"
end
