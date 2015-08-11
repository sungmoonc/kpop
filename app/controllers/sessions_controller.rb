# app/controllers/sessions_controller.rb

class SessionsController < Devise::SessionsController
  respond_to :json
end