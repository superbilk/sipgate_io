module SipgateIo
  @@configuration = nil

  def self.configure
    @@configuration = Configuration.new

    if block_given?
      yield configuration
    end

    configuration
  end

  def self.configuration
    @@configuration || configure
  end

  class Configuration
    attr_accessor :processor_class, :processor_method, :callback_url

    def processor_class
      @processor_class ||=
        begin
          if Kernel.const_defined?(:EventProcessor)
            "EventProcessor"
          else
            raise NameError.new(<<-ERROR.strip_heredoc, 'EventProcessor')
              To use SipgateIo, you must either define `EventProcessor` or configure a
              different processor. See https://github.com/superbilk/sipgate_io#defaults for
              more information.
            ERROR
          end
        end

      @processor_class.constantize
    end

    def processor_class=(klass)
      @processor_class = klass.to_s
    end

    def processor_method
      @processor_method ||= :process
    end

    def callback_url
      @callback_url ||= :callback_url
    end
  end
end
