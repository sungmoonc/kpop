class AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to("/admin/users")
  end

  def users
    if current_user["admin"]
      @users = User.all
    end
  end

  def toggle_user_admin
    user = User.find(params["user_id"])
    user[:admin] = !(params["admin"] == "true")

    if (user.save)
      render json: user
    else
      head :internal_server_error
    end
  end
end
