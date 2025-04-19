class FriendshipsController < ApplicationController
  before_action :set_friend, except: [:index]

  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @friends = (@user.friends + @user.inverse_friends).uniq
      @pending_requests = @user.inverse_friendships.where(status: 'pending')
    else
      @user = Current.user
      @friends = (Current.user.friends + Current.user.inverse_friends).uniq
      @pending_requests = Current.user.inverse_friendships.where(status: 'pending')
    end
  end

  def create
    @friendship = Current.user.friendships.build(friend: @friend, status: 'pending')

    if @friendship.save
      NotificationService.notify(
        recipient: @friend,
        actor: Current.user,
        action_type: 'friend_request',
        notifiable: @friendship
      )
      redirect_to user_profile_path(@friend), notice: "Friend request sent."
    else
      redirect_to user_profile_path(@friend), alert: "Could not send friend request."
    end
  end

  def update
    @friendship = Friendship.find_by(user: @friend, friend: Current.user, status: 'pending')
    
    if @friendship&.update(status: 'accepted')
      NotificationService.notify(
        recipient: @friend,
        actor: Current.user,
        action_type: 'friend_request_accepted',
        notifiable: @friendship
      )
      redirect_to user_profile_path(@friend), notice: "Friend request accepted."
    else
      redirect_to user_profile_path(@friend), alert: "Could not accept friend request."
    end
  end

  def destroy
    @friendship = Friendship.find_by(user: @friend, friend: Current.user) ||
                 Friendship.find_by(user: Current.user, friend: @friend)
    
    if @friendship
      was_pending = @friendship.status == 'pending'
      recipient = (@friendship.user == Current.user) ? @friendship.friend : @friendship.user
  
      @friendship.destroy
  
      if was_pending
        NotificationService.notify(
          recipient: recipient,
          actor: Current.user,
          action_type: 'friend_request_rejected',
          notifiable: @friendship
        )
      end
      
      redirect_to user_profile_path(@friend), notice: "Friend request removed."
    else
      redirect_to user_profile_path(@friend), alert: "Could not remove friend request."
    end
  end
                
  private

  def set_friend
    @friend = User.find(params[:friend_id])
  end
end
  