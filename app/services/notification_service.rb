# app/services/notification_service.rb
class NotificationService
  def self.notify(recipient:, actor:, action_type:, notifiable:)
    Notification.create!(
      recipient: recipient,
      actor: actor,
      action_type: action_type,
      notifiable: notifiable
    )
  end
end