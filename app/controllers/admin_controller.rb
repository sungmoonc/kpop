class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :isAdmin

  def isAdmin
    redirect_to "/" unless current_user["admin"]
  end

  def index
    redirect_to("/admin/users")
  end

  def users
    @users = User.all
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
