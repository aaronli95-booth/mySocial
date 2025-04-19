module NotificationsHelper
    def notification_message(notification)
      case notification.action_type
      when 'friend_request'
        'sent you a friend request'
      when 'friend_request_accepted'
        'accepted your friend request'
      when 'friend_request_rejected'
        'rejected your friend request'
      when 'new_post'
        'created a new post'
      else
        'performed an action'
      end
    end

    def notification_link(notification)
        case notification.action_type
        when 'friend_request'
          user_profile_path(notification.actor)
        when 'friend_request_accepted'
          user_profile_path(notification.actor)
        when 'friend_request_rejected'
          user_profile_path(notification.actor)
        when 'new_post'
          post_path(notification.notifiable)
        else
          '#'
        end
      end
      
  end
