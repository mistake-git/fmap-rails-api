class NotificationsController < ApplicationController
  before_action :auth
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
  
end