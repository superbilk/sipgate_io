Rails.application.routes.draw do

  mount SipgateIo::Engine => "/sipgate_io"
end
