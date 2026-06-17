class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  private

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Você precisa estar logado."
    end
  end

  def require_admin
    require_login
    return if performed?
    unless current_user.admin?
      redirect_to root_path, alert: "Você não tem permissão para acessar esta funcionalidade."
    end
  end

  def require_coordinator
    require_login
    return if performed?
    unless current_user.coordinator?
      redirect_to root_path, alert: "Você não tem permissão para acessar esta funcionalidade."
    end
  end
end
