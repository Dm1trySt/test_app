class UsersController < ApplicationController

  before_action :find_user, only: [:update, :destroy]
  before_action :authenticate_user!, except: [:create]
  def index
    users = User.all
    render_json(users)
  end

  def show; end

  def create
    user = User.new(user_params)
    user.save
    render_json(user,:created )
  end

  def update
    @user.update(user_params)
    render_json(@user)
  end

  def destroy
    if @user.destroy
      render_json({message: "User deleted successfully", id: params[:id]})
    else
      render_json(@user)
    end
  end

  def update_api_key
    if @user.update_key!
      render_json({
                    message: "API key updated successfully",
                    api_key: @user.api_key,
                    expires_at: @user.api_key_expires_at
                  })
    else
      render_json(@user)
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
