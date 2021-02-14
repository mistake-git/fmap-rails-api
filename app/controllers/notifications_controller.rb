class NotificationsController < ApplicationController
  before_action :set_current_user 

  def index
    notifications = @current_user.passive_notifications
    render json: notifications
  end

  def check
    notifications = @current_user.passive_notifications
    notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
    render json: notifications
  end

  private

  def set_current_user
    @current_user = User.find_by(uid: params[:user_id])
  end
  
end