class SenhaController < ApplicationController
  before_action :require_login, only: [ :redefinir, :atualizar ]

  TOKEN_EXPIRY = 2.hours

  # GET /senha/redefinir (logged in — change current password)
  def redefinir; end

  # POST /senha/redefinir
  def atualizar
    usuario = current_usuario
    if usuario.authenticate(params[:password])
      if usuario.update(password: params[:new_password_1], password_confirmation: params[:new_password_2])
        redirect_to senha_redefinir_path, notice: "Senha alterada com sucesso!"
      else
        flash.now[:alert] = usuario.errors[:password].first || usuario.errors.full_messages.first
        render :redefinir, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Senha atual está incorreta."
      render :redefinir, status: :unprocessable_entity
    end
  end

  # GET /senha/recuperar
  def recuperar; end

  # POST /senha/recuperar — generate token and log the "email"
  def solicitar
    usuario = Usuario.find_by(email: params[:email].to_s.downcase.strip)
    if usuario
      token = SecureRandom.urlsafe_base64(32)
      usuario.update_columns(
        password_reset_token:   token,
        password_reset_sent_at: Time.current
      )
      log_reset_email(usuario, token)
    end
    # Same message whether email exists or not (prevents enumeration)
    redirect_to recuperar_senha_path,
      notice: "Se este e-mail estiver cadastrado, você receberá instruções em breve."
  end

  # GET /senha/nova?token=xxx
  def nova
    @token = params[:token]
    unless find_usuario_by_token(@token)
      redirect_to recuperar_senha_path, alert: "Link de redefinição inválido ou expirado."
    end
  end

  # POST /senha/nova
  def salvar
    @token = params[:token]
    usuario = find_usuario_by_token(@token)
    unless usuario
      redirect_to recuperar_senha_path, alert: "Link de redefinição inválido ou expirado."
      return
    end

    if usuario.update(password: params[:password], password_confirmation: params[:password_confirmation])
      usuario.update_columns(password_reset_token: nil, password_reset_sent_at: nil)
      redirect_to login_path, notice: "Senha redefinida com sucesso! Faça login com sua nova senha."
    else
      flash.now[:alert] = usuario.errors[:password].first || usuario.errors.full_messages.first
      render :nova, status: :unprocessable_entity
    end
  end

  private

  def find_usuario_by_token(token)
    return nil if token.blank?
    usuario = Usuario.find_by(password_reset_token: token)
    return nil unless usuario
    return nil if usuario.password_reset_sent_at.nil? || usuario.password_reset_sent_at < TOKEN_EXPIRY.ago
    usuario
  end

  def log_reset_email(usuario, token)
    reset_url = "#{request.base_url}/senha/nova?token=#{token}"
    log_dir = Rails.root.join("notificacoes")
    FileUtils.mkdir_p(log_dir)
    log_path = log_dir.join("redefinicao_senha.log")
    content = <<~LOG
      ============================================================
      #{Time.current.strftime('%d/%m/%Y às %H:%M:%S')}
      Para:    #{usuario.email}
      Assunto: Redefinição de senha — CAMAAR

      Olá, #{usuario.nome}!

      Você solicitou a redefinição de senha no sistema CAMAAR.
      Acesse o link abaixo para criar uma nova senha (válido por 2 horas):

        #{reset_url}

      Se você não realizou essa solicitação, ignore este email.

      Atenciosamente,
      Equipe CAMAAR — Universidade de Brasília

    LOG
    File.open(log_path, "a", encoding: "UTF-8") { |f| f.write(content) }
  end
end
