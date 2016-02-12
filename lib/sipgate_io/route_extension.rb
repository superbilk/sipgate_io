module SipgateIo
  module RouteExtensions
    def mount_sipgate_io(path='/sipgate_io')
      post path => 'sipgate_io/events#create', as: :sipgate_io
    end
  end
end
