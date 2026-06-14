class SenhaController < ApplicationController
  before_action :require_login

  def redefinir
    usuario = @current_usuario
    if usuario&.authenticate(params[:password])
      texto = "As senhas não são as mesmas"
      flash.now[:alert] = texto unless usuario.update(password: params[:new_password_1], password_confirmation: params[:new_password_2])
    else
      flash.now[:alert] = "Senha antiga está incorreta"
    end
  end
end
