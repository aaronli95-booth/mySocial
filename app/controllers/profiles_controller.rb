class ProfilesController < ApplicationController
  def show
    @user = Current.user
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    
    if params[:user][:avatar].present?
      Rails.logger.debug "Avatar file received: #{params[:user][:avatar].original_filename}"
    end

    if @user.update(profile_params)
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

  def profile_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :school,
      :bio,
      :avatar
    )
  end
end
