class NotificationsController < ApplicationController
  before_action :set_notification, only: [:mark_as_read]

  def index
    @notifications = Current.user.notifications.recent
  end

  def mark_as_read
    @notification.mark_as_read!
    respond_to do |format|
      format.html { redirect_back fallback_location: notifications_path }
      format.json { render json: { success: true } }
    end
  end

  def mark_all_as_read
    Current.user.notifications.unread.update_all(read_at: Time.current)
    respond_to do |format|
      format.html { redirect_back fallback_location: notifications_path }
      format.json { render json: { success: true } }
    end
  end

  def mark_as_seen
    Current.user.notifications.unread.update_all(seen_at: Time.current)
    head :ok
  end

  private

  def set_notification
    @notification = Current.user.notifications.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to notifications_path, alert: "Notification not found."
  end
end
