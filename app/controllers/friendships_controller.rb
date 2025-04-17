class FriendshipsController < ApplicationController
  before_action :set_friend, except: [:index]

  def index
    puts "Current user: #{Current.user.inspect}"
    @friends = (Current.user.friends + Current.user.inverse_friends).uniq
    puts "Friends count: #{@friends.count}"
    puts "Friends: #{@friends.inspect}"
    @pending_requests = Current.user.inverse_friendships.where(status: 'pending')
    puts "Pending requests count: #{@pending_requests.count}"
  end

  def create
    @friendship = Current.user.friendships.build(friend: @friend, status: 'pending')

    if @friendship.save
      redirect_to user_profile_path(@friend), notice: "Friend request sent."
    else
      redirect_to user_profile_path(@friend), alert: "Could not send friend request."
    end
  end

  def update
    @friendship = Friendship.find_by(user: @friend, friend: Current.user, status: 'pending')
    
    if @friendship&.update(status: 'accepted')
      redirect_to user_profile_path(@friend), notice: "Friend request accepted."
    else
      redirect_to user_profile_path(@friend), alert: "Could not accept friend request."
    end
  end

  def destroy
    @friendship = Friendship.find_by(user: @friend, friend: Current.user) ||
                 Friendship.find_by(user: Current.user, friend: @friend)
    
    if @friendship&.destroy
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
  