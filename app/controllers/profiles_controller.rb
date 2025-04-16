class ProfilesController < ApplicationController
  before_action :require_authentication
  before_action :set_user, only: [:show]

  def show
    Rails.logger.debug "Show action - params: #{params.inspect}"
    Rails.logger.debug "Show action - @user: #{@user.inspect}"
    # @user is already set by set_user
    if @user.nil?
      redirect_to root_path, alert: "User not found"
    end
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    
    if params[:user][:avatar].present?
      Rails.logger.debug "Avatar file received: #{params[:user][:avatar].original_filename}"
    end

    if @user.update(user_params)
      if @user.avatar.attached?
        Rails.logger.debug "Avatar successfully attached"
      end
      redirect_to profile_path, notice: "Profile updated successfully"
    else
      Rails.logger.debug "Profile update failed: #{@user.errors.full_messages}"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    Rails.logger.debug "set_user - params: #{params.inspect}"
    if params[:id].present?
      @user = User.find_by(id: params[:id])
      Rails.logger.debug "set_user - found user: #{@user.inspect}"
    else
      @user = Current.user
      Rails.logger.debug "set_user - using current user: #{@user.inspect}"
    end
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :school,
      :bio,
      :avatar
    )
  end
end
