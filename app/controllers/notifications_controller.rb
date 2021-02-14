class NotificationsController < ApplicationController
  before_action :set_current_user 
  before_action :set_notifications

  def index
    render json: @notifications
  end

  def check
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def unchecked_notification_count
    count = @notifications.where(checked: false).count
    render json: count
  end

  def set_notifications
    @notifications = @current_user.passive_notifications.all
  end

  private

  def set_current_user
    @current_user = User.find_by(uid: params[:user_id])
  end
  
end