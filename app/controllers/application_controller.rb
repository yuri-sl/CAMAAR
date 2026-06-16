class ApplicationController < ActionController::Base
  helper_method :current_usuario, :logged_in?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  stale_when_importmap_changes
  private

  def current_usuario
    @current_usuario ||= Usuario.find_by(id: session[:usuario_id]) if session[:usuario_id]
  end

  def logged_in?
    current_usuario.present?
  end

  def require_login
    redirect_to login_path, alert: "Você precisa estar logado." unless logged_in?
  end
  def require_admin
    redirect_to root_path, alert: "Acesso restrito." unless current_usuario&.admin?
  end
end
