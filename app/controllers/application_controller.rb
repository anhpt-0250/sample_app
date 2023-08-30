class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include Pagy::Backend
  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options options = {}
    {locale: I18n.locale}.merge options
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "please_login"
    store_location
    redirect_to login_path
  end
end
