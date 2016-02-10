Rails.application.routes.draw do
  post 'event' => 'sipgate_io/event#handle'
end
