class ApplicationController < ActionController::Base
  
  before_action :set_locale
  
  rescue_from AbstractController::ActionNotFound, with: :redirect_to_home
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = t("not_authorized")
    redirect_back fallback_location: root_path
  end

  def change_locale
    session[:locale] = params[:locale]
    redirect_back fallback_location: root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  private

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def redirect_to_home
    redirect_to root_path
  end

end