class SenhaController < ApplicationController
  before_action :require_login, only: [ :redefinir, :atualizar ]

  # GET /senha/redefinir (logged in — change current password)
  def redefinir; end

  # POST /senha/redefinir
  def atualizar
    usuario = current_usuario
    if usuario.authenticate(params[:password])
      if params[:new_password_1] != params[:new_password_2]
        flash.now[:alert] = "As senhas não são as mesmas"
        render :redefinir, status: :unprocessable_entity
        return
      end
      if usuario.update(password: params[:new_password_1], password_confirmation: params[:new_password_2])
        redirect_to senha_redefinir_path, notice: "Senha alterada com sucesso!"
      else
        flash.now[:alert] = usuario.errors[:password].first || usuario.errors.full_messages.first
        render :redefinir, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Senha antiga está incorreta"
      render :redefinir, status: :unprocessable_entity
    end
  end

  # GET /senha/recuperar
  def recuperar; end

  # POST /senha/recuperar — stateless token via generates_token_for (no DB write needed)
  def solicitar
    usuario = Usuario.find_by(email: params[:email].to_s.downcase.strip)
    if usuario
      token = usuario.generate_token_for(:password_reset)
      log_reset_email(usuario, token)
    end
    redirect_to recuperar_senha_path,
      notice: "Se este e-mail estiver cadastrado, você receberá instruções em breve."
  end

  # GET /senha/nova?token=xxx
  def nova
    @token = params[:token]
    unless Usuario.find_by_token_for(:password_reset, @token)
      redirect_to recuperar_senha_path, alert: "Link de redefinição inválido ou expirado."
    end
  end

  # POST /senha/nova
  def salvar
    @token = params[:token]
    usuario = find_usuario_by_token_or_redirect(@token)
    return unless usuario
    senha = params[:password].to_s
    confirmacao = params[:password_confirmation].to_s

    return unless password_present?(senha)
    return unless passwords_match?(senha, confirmacao)
    return unless new_password_different?(usuario, senha)

    if usuario.update(password: senha, password_confirmation: confirmacao)
      redirect_to login_path, notice: "Senha redefinida com sucesso! Faça login com sua nova senha."
    else
      flash.now[:alert] = usuario.errors[:password].first || usuario.errors.full_messages.first
      render :nova, status: :unprocessable_entity
    end
  end

  private

  # Localiza um usuário pelo token de redefinição de senha.
  #
  # Utiliza o método <tt>find_by_token_for</tt> com o propósito
  # <tt>:password_reset</tt> para validar o token de forma stateless,
  # sem necessidade de persistência no banco de dados.
  #
  # Se o token for inválido ou expirado (usuário não encontrado),
  # redireciona para +recuperar_senha_path+ com mensagem de alerta
  # e retorna +nil+, interrompendo o fluxo da ação +salvar+.
  #
  # ==== Parâmetros
  # [token] Token de redefinição de senha gerado por
  #         <tt>usuario.generate_token_for(:password_reset)</tt>.
  #
  # ==== Retorno
  # [Usuario] se o token for válido e o usuário for encontrado.
  # [nil]     se o token for inválido ou expirado (com redirecionamento).
  def find_usuario_by_token_or_redirect(token)
    usuario = Usuario.find_by_token_for(:password_reset, token)
    unless usuario
      redirect_to recuperar_senha_path, alert: "Link de redefinição inválido ou expirado."
      return nil
    end
    usuario
  end

  # Verifica se a nova senha foi preenchida.
  #
  # Valida que o campo de senha não está em branco.
  #
  # Se a senha estiver em branco, define mensagem de alerta via
  # <tt>flash.now</tt> e renderiza a view +:nova+ com status
  # HTTP 422 (Unprocessable Entity), interrompendo o fluxo da ação +salvar+.
  #
  # ==== Parâmetros
  # [senha] String com a nova senha informada pelo usuário
  #         (<tt>params[:password]</tt>).
  #
  # ==== Retorno
  # [true]  se a senha foi preenchida.
  # [false] se a senha está em branco (com renderização da view).
  def password_present?(senha)
    if senha.blank?
      flash.now[:alert] = "A nova senha é obrigatória."
      render :nova, status: :unprocessable_entity
      return false
    end
    true
  end

  # Verifica se a nova senha e a confirmação são iguais.
  #
  # Compara os dois campos informados pelo usuário para garantir
  # que não houve erro de digitação.
  #
  # Se as senhas forem diferentes, define mensagem de alerta via
  # <tt>flash.now</tt> e renderiza a view +:nova+ com status
  # HTTP 422 (Unprocessable Entity), interrompendo o fluxo da ação +salvar+.
  #
  # ==== Parâmetros
  # [senha]       String com a nova senha
  #               (<tt>params[:password]</tt>).
  # [confirmacao] String com a confirmação da nova senha
  #               (<tt>params[:password_confirmation]</tt>).
  #
  # ==== Retorno
  # [true]  se as senhas são iguais.
  # [false] se as senhas são diferentes (com renderização da view).
  def passwords_match?(senha, confirmacao)
    if senha != confirmacao
      flash.now[:alert] = "As duas senhas não são iguais."
      render :nova, status: :unprocessable_entity
      return false
    end
    true
  end

  # Verifica se a nova senha é diferente da senha atual do usuário.
  #
  # Utiliza o método <tt>authenticate</tt> do <tt>has_secure_password</tt>
  # para comparar a nova senha com a senha atual armazenada.
  #
  # Se a nova senha for igual à senha atual, define mensagem de alerta
  # via <tt>flash.now</tt> e renderiza a view +:nova+ com status
  # HTTP 422 (Unprocessable Entity), interrompendo o fluxo da ação +salvar+.
  #
  # ==== Parâmetros
  # [usuario] Instância de <tt>Usuario</tt> dono do token de redefinição.
  # [senha]   String com a nova senha informada
  #           (<tt>params[:password]</tt>).
  #
  # ==== Retorno
  # [true]  se a nova senha é diferente da senha atual.
  # [false] se a nova senha é igual à senha atual (com renderização da view).
  def new_password_different?(usuario, senha)
    if usuario.authenticate(senha)
      flash.now[:alert] = "A nova senha deve ser diferente da senha atual."
      render :nova, status: :unprocessable_entity
      return false
    end
    true
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
      Acesse o link abaixo para criar uma nova senha (válido por 48 horas):

        #{reset_url}

      Se você não realizou essa solicitação, ignore este email.

      Atenciosamente,
      Equipe CAMAAR — Universidade de Brasília

    LOG
    File.open(log_path, "a", encoding: "UTF-8") { |f| f.write(content) }
  end
end
