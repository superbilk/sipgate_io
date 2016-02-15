require 'builder'

module SipgateIo
  class XmlResponse
    class << self

      def dial(options = {})
        anonymous = options[:clip] == :anonymous ? Hash[ anonymous: true ] : nil
        caller_id = !!/\d+/.match(options[:clip]) ? Hash[ callerId: options[:clip] ] : nil

        builder(options) do |b|
          b.Dial(anonymous, caller_id) do |b|
            options[:target] == :voicemail ? b.Voicemail : b.Number(options[:target])
          end
        end
      end

      def play(options = {})
        url = options[:soundfile_url]

        builder(options) { |b| b.Play { |b| b.Url(url) } }
      end

      def gather(options = {})
        on_data = Hash[ onData: SipgateIo.configuration.callback_url ]
        max_digits = parse_option(options, :max_digits, :maxDigits)
        timeout = parse_option(options, :timeout)
        play_url = options.key?(:soundfile_url) ? options[:soundfile_url] : nil

        builder(options) do |b|
          b.Gather(on_data,
                   max_digits,
                   timeout) do |b|
            unless play_url.nil?
              b.Play { |b| b.Url(play_url) }
            end
          end
        end
      end

      def reject(options = {})
        reason = parse_option(options, :reason)

        builder(options) { |b| b.Reject(reason) }
      end

      def hangup(options = {})
        builder(options) { |b| b.Hangup }
      end

      def on_answer
        builder(Hash[ callback: :on_answer ])
      end

      def on_hangup
        builder(Hash[ callback: :on_hangup ])
      end

      private

      def parse_option(options, key, xml_key_name = nil)
        xml_key_name ||= key
        options.key?(key) ? Hash[ xml_key_name => options[key] ] : nil
      end

      def with_callback(options)
        return nil unless options.key?(:callback)
        type = (options[:callback] == :on_answer) ? :onAnswer : :onHangup
        Hash[ type => SipgateIo.configuration.callback_url ]
      end

      def builder(options)
        xml = Builder::XmlMarkup.new(indent: 2)
        xml.instruct!
        xml.Response(with_callback(options)) do |response|
          yield(response) if block_given?
        end
      end

    end
  end
end
