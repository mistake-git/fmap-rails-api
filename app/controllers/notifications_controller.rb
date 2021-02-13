class NotificationsController < ApplicationController
  before_action :set_current_user 
  before_action :set_notifications

  def index
    render json: notifications
  end

  def check
    notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
    render json: notifications
  end

  private

  def set_current_user
    @current_user = User.find(params[:user_id])
  end

  def set_notifications
    notifications = @current_user.passive_notifications
  end
  
end