class RelationshipsController < ApplicationController
  before_action :set_user

  def index
    render json: @current_user.followings
  end

  def create
    following = @current_user.follow(@other_user)
    following.save
    render json: @current_user.followings
  end

  def destroy
    following = @current_user.unfollow(@other_user)
    following.destroy
    render json: @current_user.followings
  end

  private

  def set_user
    @current_user = User.find(params[:user_id])
    @other_user = User.find(params[:follow_id])
  end

end
