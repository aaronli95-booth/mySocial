class ProfilesController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
  end

  def update
    if params[:user][:avatar].present?
      @user.avatar.attach(params[:user][:avatar])
    end

    if @user.update(user_params.except(:avatar))
      redirect_to profile_path, notice: 'Profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    if params[:id].present?
      # For viewing other users' profiles
      @user = User.find_by(id: params[:id])
    else
      # For current user's profile
      @user = Current.user
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :school, :bio, :avatar)
  end
end
