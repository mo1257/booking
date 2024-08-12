class UsersController < ApplicationController
  before_action :authenticate_user!

  def account
    @user = current_user
  end

  def profile
    @user = current_user
  end

  def edit_profile
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_users_path, notice: 'プロフィールが更新されました。'
    else
      render :profile_edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :name, :introduction)
  end
end
