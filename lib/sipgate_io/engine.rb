module SipgateIo
  class Engine < ::Rails::Engine
    isolate_namespace SipgateIo
    initializer 'sipgate_io.routes',
      after: 'action_dispatch.prepare_dispatcher' do |app|

      ActionDispatch::Routing::Mapper.send :include, SipgateIo::RouteExtensions
    end
  end
end
