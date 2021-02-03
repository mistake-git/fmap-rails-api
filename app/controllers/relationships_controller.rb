class RelationshipsController < ApplicationController
  before_action :set_user

  def create
    @current_user.follow(@other_user)
    render json: @other_user
  end

  def destroy
    @current_user.unfollow(@other_user)
  end

  private

  def set_user
    @current_user = User.find(params[:user_id])
    @other_user = User.find(params[:follow_id])
  end

end
