class PasswordResetsController < ApplicationController
  # Viet 1 dong thi robocop detected a
  before_action :load_user, :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "create_info"
      redirect_to root_url
    else
      flash.now[:danger] = t "create_danger"
      render :new
    end
  end

  def update
    if user_params[:password].empty? # Case 3
      @user.errors.add :password, t("can't_empty")
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params # Case 4
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "reset_done"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity # Case 2
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "not_found"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "user_in_actived"
    redirect_to root_url
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "reset_expire"
    redirect_to new_password_reset_url
  end
end
