class ApplicationController < ActionController::Base
  protect_from_forgery

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  before_filter :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
