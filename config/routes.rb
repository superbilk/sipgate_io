Rails.application.routes.draw do
  post 'new_call' => 'sipgate_io/new_call#process_call'
end
