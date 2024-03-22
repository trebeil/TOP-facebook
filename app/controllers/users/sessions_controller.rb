# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  skip_before_action :require_name
  prepend_before_action :validate_recaptchas, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    ActionCable.server.remote_connections.where(current_user: current_user).disconnect
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def validate_recaptchas
    v3_verify = verify_recaptcha action: 'signin', minimum_score: 0.9, secret_key: Rails.application.credentials.RECAPTCHA_SECRET_V3
    v2_verify = verify_recaptcha secret_key: Rails.application.credentials.RECAPTCHA_SECRET
    return if v3_verify || v2_verify

    self.resource = resource_class.new sign_in_params
    respond_with_navigational(resource) { render :new }
  end
end
