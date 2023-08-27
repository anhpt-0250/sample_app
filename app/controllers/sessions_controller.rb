class SessionsController < ApplicationController
  def new; end

  def destroy
    log_out
    redirect_to root_url
  end

  def create
    user = User.find_by email: params[:session][:email]&.downcase
    if user_authenticated?(user)
      handle_successful_login(user)
    else
      handle_failed_login
    end
  end

  private

  def user_authenticated? user
    user.try(:authenticate, params.dig(:session, :password))
  end

  def handle_successful_login user
    reset_session
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    log_in user
    redirect_to user
  end

  def handle_failed_login
    # Create an error message.
    flash.now[:danger] = t("invalid_mess")
    render :new, status: :unprocessable_entity
  end
end
