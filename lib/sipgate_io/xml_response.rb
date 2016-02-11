require 'builder'

module SipgateIo
  class XmlResponse

    def self.dial
    end

    def self.play(url)
      # <?xml version="1.0" encoding="UTF-8"?>
      # <Response>
      #     <Play>
      #         <Url>http://example.com/example.wav</Url>
      #     </Play>
      # </Response>
    end

    def self.gather
    end

    def self.reject(reason = :rejected)
      self.builder.response { |b| b.reject(reason: reason) }
    end

    def self.hangup
      self.builder.response { |b| b.hangup }
    end

    private

    def self.builder
      b = Builder::XmlMarkup.new(indent: 2)
      b.instruct!
      b
    end

  end
end

# puts SipgateIo::XmlResponse.reject
# puts SipgateIo::XmlResponse.reject(:busy)
# puts SipgateIo::XmlResponse.reject
# puts SipgateIo::XmlResponse.hangup
