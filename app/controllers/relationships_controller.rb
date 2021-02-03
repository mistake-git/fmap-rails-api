class RelationshipsController < ApplicationController
  before_action :set_user

  def create
    following = @current_user.follow(@other_user)
    render json: @other_user
  end

  def destroy
    following = @current_user.unfollow(@other_user)
    following.destroy
  end

  private

  def set_user
    @current_user = User.find(params[:user_id])
    @other_user = User.find(params[:follow_id])
  end

end
