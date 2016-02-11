require 'builder'

module SipgateIo
  class XmlResponse

    def self.dial(target, options = nil)
      self.builder.response do |b|
        if target == :voicemail
          b.dial { |b| b.voicemail }
        elsif options.nil?
          b.dial { |b| b.number(target) }
        elsif !options[:anonymous].nil?
          b.dial(anonymous: true) { |b| b.number(target) }
        elsif !options[:caller_id].nil?
          b.dial(callerId: options[:caller_id]) { |b| b.number(target) }
        end
      end
    end

    def self.play(url)
      self.builder.response { |b| b.play { |b| b.url(url) } }
    end

    def self.gather(options = nil)
      options ||= {}
      options[:type] ||= :dtmf
      options[:callback_url] ||= SipgateIo.configuration.callback_url
      options[:max_digits] ||= 1
      options[:timeout] ||= 1000
      self.builder.response do |b|
        b.gather(onData: options[:callback_url],
                 maxDigits: options[:max_digits],
                 timeout: options[:timeout]) do |b|
          unless options[:play_url].nil?
            b.play { |b| b.url(options[:play_url]) }
          end
        end
      end
    end

    # <?xml version="1.0" encoding="UTF-8"?>
    # <Response>
    #     <Gather onData="http://localhost:3000/dtmf" maxDigits="3" timeout="10000">
    #         <Play>
    #             <Url>https://example.com/example.wav</Url>
    #         </Play>
    #     </Gather>
    # </Response>

    def self.reject(reason = nil)
      self.builder.response do |b|
        if reason.nil?
          b.reject
        else
          b.reject(reason: reason)
        end
      end
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

# puts SipgateIo::XmlResponse.gather()
# puts SipgateIo::XmlResponse.gather(play_url: "http://google.de")

# puts SipgateIo::XmlResponse.play("http://google.de")
# puts SipgateIo::XmlResponse.dial(:voicemail)
# puts SipgateIo::XmlResponse.dial("491234567")
# puts SipgateIo::XmlResponse.dial("491234567", anonymous: true)
# puts SipgateIo::XmlResponse.dial("491234567", caller_id: "555")

# puts SipgateIo::XmlResponse.reject
# puts SipgateIo::XmlResponse.reject(:busy)
# puts SipgateIo::XmlResponse.reject(:rejected)
# puts SipgateIo::XmlResponse.hangup
