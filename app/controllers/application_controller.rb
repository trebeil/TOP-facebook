class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  append_before_action :require_name

  def require_name
    redirect_to '/accounts/complete' if [nil, ''].include?(current_user.name.strip) ||
                                        [nil, ''].include?(current_user.last_name.strip)
  end
end
