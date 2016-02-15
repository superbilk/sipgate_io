module SipgateIo
  module EventProcessor

    def process
      processor_class.new(self).public_send(processor_method)
    end

    private

    delegate :processor_class, :processor_method, to: :sipgate_io_configuration

    def process_event(event)
      processor_class.new(event).public_send(processor_method)
    end

    def sipgate_io_configuration
      SipgateIo.configuration
    end
  end
end
