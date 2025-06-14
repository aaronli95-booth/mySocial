class RegistrationsController < ApplicationController
  skip_before_action :require_authentication
  def new
    @user = User.new
  end

  def create
    if @user = User.create(user_params)
      start_new_session_for @user
      redirect_to root_path, notice: "User account was successfully created"
    else
      render :new
    end
  end

private

  def user_params
    params.require(:user).permit(
      :email_address, 
      :password,
      :first_name,
      :last_name,
      :school,
      :bio
    )
  end
end
