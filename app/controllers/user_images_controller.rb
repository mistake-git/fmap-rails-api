class UserImagesController < ApplicationController
  before_action :auth
  before_action :require_auth

  def update
    if @current_user.update(user_params)
      render json: @user
    else
      render json: @current_user.errors
    end
  end

  def destroy
    @user.image.purge if @current_user.image.attached?
    render json: @current_user
  end

  private

  def user_params
    params.permit(:uid, :image)
  end

end
