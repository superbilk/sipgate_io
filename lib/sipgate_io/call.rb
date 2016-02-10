module SipgateIo
  class Call
    attr_reader :to, :from, :direction, :event, :call_id, :users

    def initialize(params)
      @to = params[:to]
      @from = params[:from]
      @direction = params[:direction]
      @event = params[:event]
      @call_id = params[:callId]
      @users = params[:user]
    end

  #   private
  #
  #   attr_reader :params
  #
  #   def config
  #     @config ||= Griddler.configuration
  #   end
  #
  #   def recipients(type)
  #     params[type].to_a.map { |recipient| extract_address(recipient) }
  #   end
  #
  #   def extract_address(address)
  #     EmailParser.parse_address(clean_text(address))
  #   end
  #
  #   def extract_subject
  #     clean_text(params[:subject])
  #   end
  #
  #   def extract_body
  #     EmailParser.extract_reply_body(text_or_sanitized_html)
  #   end
  #
  #   def extract_headers
  #     if params[:headers].is_a?(Hash)
  #       deep_clean_invalid_utf8_bytes(params[:headers])
  #     else
  #       EmailParser.extract_headers(clean_invalid_utf8_bytes(params[:headers]))
  #     end
  #   end
  #
  #   def extract_cc_from_headers(headers)
  #     EmailParser.extract_cc(headers)
  #   end
  #
  #   def text_or_sanitized_html
  #     text = clean_text(params.fetch(:text, ''))
  #     text.presence || clean_html(params.fetch(:html, '')).presence
  #   end
  end
end
