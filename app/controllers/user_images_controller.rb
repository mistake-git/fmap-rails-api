class UserImagesController < ApplicationController
  before_action :set_user
  
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors
    end
  end

  def destroy
    if @user.image.attached?
      @user.image.purge
    end
    render json: @user
  end

  private

  def user_params
    params.permit(:uid, :image)
  end

  def set_user
    @user = User.find_by(uid: params[:id])
  end

end
