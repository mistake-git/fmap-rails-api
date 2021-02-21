class RelationshipsController < ApplicationController
  before_action :set_other_user
  before_action :auth

  def create
    @current_user.follow(@other_user)
    @other_user.create_notification_follow(@current_user)
    render json: @other_user
  end

  def destroy
    @current_user.unfollow(@other_user)
    render json: @other_user
  end

  def is_followed
    is_followed = @current_user.following?(@other_user)
    render json: is_followed
  end

  private

  def set_other_user
    @other_user = User.find(params[:follow_id])
  end

end
