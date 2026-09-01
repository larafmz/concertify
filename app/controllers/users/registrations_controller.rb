class Users::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters

  def edit
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    resource.build_ubication unless resource.ubication
    super
  end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :role_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :description, :icon, ubication_attributes: [:country_id, :city]])
  end 

  def update_resource(resource, params)
    if params[:password].present? || params[:password_confirmation].present?
      resource.update_with_password(params)
    else
      resource.update_without_password(params.except(:current_password))
    end
  end

  def after_update_path_for(resource_or_scope)
    user_path(resource_or_scope)
  end

end