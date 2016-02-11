SipgateIo.configure do |config|
  config.processor_class = EventProcessor # CommentViaEmail
  config.processor_method = :process # :create_comment (A method on CommentViaEmail)
end
