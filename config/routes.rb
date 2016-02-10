Rails.application.routes.draw do
  post 'event_processor' => 'sipgate_io/events#create'
end
