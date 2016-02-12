require 'builder'

module SipgateIo
  class XmlResponse

    def self.dial(options = {})
      anonymous = options[:clip] == :anonymous ? Hash[ anonymous: true ] : nil
      caller_id = !!/\d+/.match(options[:clip]) ? Hash[ callerId: options[:clip] ] : nil
      self.builder.Response(set_callback(options)) do |b|
        b.Dial(anonymous, caller_id) do |b|
          options[:target] == :voicemail ? b.Voicemail : b.Number(options[:target])
        end
      end
    end

    def self.play(options = {})
      url = options[:soundfile_url]
      self.builder.Response(set_callback(options)) { |b| b.Play { |b| b.Url(url) } }
    end

    def self.gather(options = {})
      on_data = Hash[ onData: SipgateIo.configuration.callback_url ]
      max_digits = options.key?(:max_digits) ? Hash[ maxDigits: options[:max_digits] ] : nil
      timeout = options.key?(:timeout) ? Hash[ timeout: options[:timeout] ] : nil
      play_url = options.key?(:soundfile_url) ? options[:soundfile_url] : nil

      self.builder.Response(set_callback(options)) do |b|
        b.Gather(on_data,
                 max_digits,
                 timeout) do |b|
          unless play_url.nil?
            b.Play { |b| b.Url(play_url) }
          end
        end
      end
    end

    def self.reject(options = {})
      reason = options.key?(:reason) ? Hash[ reason: options[:reason] ] : nil
      self.builder.Response(set_callback(options)) { |b| b.Reject(reason) }
    end

    def self.hangup(options = {})
      self.builder.Response(set_callback(options)){ |b| b.Hangup }
    end

    def self.on_answer
      self.builder.Response(set_callback(Hash[ callback: :on_answer ]) )
    end

    def self.on_hangup
      self.builder.Response(set_callback(Hash[ callback: :on_hangup ]) )
    end

    private

    def self.set_callback(options)
      return nil unless options.key?(:callback)
      type = (options[:callback] == :on_answer) ? :onAnswer : :onHangup
      Hash[ type => SipgateIo.configuration.callback_url ]
    end

    def self.builder
      b = Builder::XmlMarkup.new(indent: 2)
      b.instruct!
      b
    end

  end
end
