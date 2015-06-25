class AdminController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def users
    @users = User.all
  end

  def toggle_user_admin
    p params
    user = User.find(params["user_id"])
    p params["admin"]
    user[:admin] = !(params["admin"] == "true")

    p user

    if (user.save)
      render json: user
    else
      head :internal_server_error
    end
  end
end
