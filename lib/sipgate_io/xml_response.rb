require 'builder'

module SipgateIo
  class XmlResponse

    def self.dial(target, options = nil)
      self.builder.Response do |b|
        if target == :voicemail
          b.Dial { |b| b.Voicemail }
        elsif options.nil?
          b.Dial { |b| b.Number(target) }
        elsif !options[:anonymous].nil?
          b.Dial(anonymous: true) { |b| b.Number(target) }
        elsif !options[:caller_id].nil?
          b.Dial(callerId: options[:caller_id]) { |b| b.Number(target) }
        end
      end
    end

    def self.play(url)
      self.builder.Response { |b| b.Play { |b| b.Url(url) } }
    end

    def self.gather(options = nil)
      options ||= {}
      options[:type] ||= :dtmf
      options[:callback_url] ||= SipgateIo.configuration.callback_url
      options[:max_digits] ||= 1
      options[:timeout] ||= 1000
      self.builder.Response do |b|
        b.Gather(onData: options[:callback_url],
                 maxDigits: options[:max_digits],
                 timeout: options[:timeout]) do |b|
          unless options[:play_url].nil?
            b.Play { |b| b.Url(options[:play_url]) }
          end
        end
      end
    end

    def self.reject(reason = nil)
      self.builder.Response do |b|
        if reason.nil?
          b.Reject
        else
          b.Reject(reason: reason)
        end
      end
    end

    def self.hangup
      self.builder.Response { |b| b.Hangup }
    end

    def self.on_answer
      self.builder.Response(onAnswer: SipgateIo.configuration.callback_url)
    end

    def self.on_hangup
      self.builder.Response(onHangup: SipgateIo.configuration.callback_url)
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
