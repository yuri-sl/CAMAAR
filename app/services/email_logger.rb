class EmailLogger
  LOG_DIR = Rails.root.join("notificacoes")

  def initialize
    FileUtils.mkdir_p(LOG_DIR)
    @entries = []
  end

  def log_boas_vindas(nome:, email:, senha_temporaria:)
    @entries << build_email(nome: nome, email: email, senha_temporaria: senha_temporaria)
  end

  # Escreve o log do arquivo e retorna o path. Retorna nil se não houverem entradas.
  def flush
    return nil if @entries.empty?

    path = next_log_path
    File.write(path, build_content, encoding: "UTF-8")
    path
  end

  private

  def next_log_path
    last = Dir[LOG_DIR.join("emails_disparados_*.log")]
              .filter_map { |f| File.basename(f).match(/emails_disparados_(\d+)\.log/)&.captures&.first&.to_i }
              .max || 0
    LOG_DIR.join("emails_disparados_#{last + 1}.log")
  end

  def build_content
    sep = "=" * 60
    header = <<~HEADER
      CAMAAR — Notificações de Credenciais de Acesso
      Gerado em: #{Time.current.strftime('%d/%m/%Y às %H:%M:%S')}
      Total de emails: #{@entries.size}

      #{sep}

    HEADER

    body = @entries.each_with_index.map do |entry, i|
      "[#{i + 1}/#{@entries.size}]\n#{entry}"
    end.join("\n#{sep}\n\n")

    header + body
  end

  def build_email(nome:, email:, senha_temporaria:)
    <<~EMAIL
      Para:    #{email}
      Assunto: Bem-vindo ao CAMAAR — Suas credenciais de acesso

      Olá, #{nome}!

      Você foi cadastrado no sistema CAMAAR da Universidade de Brasília.

      Suas credenciais de acesso são:

        E-mail:           #{email}
        Senha temporária: #{senha_temporaria}

      Acesse o sistema utilizando as credenciais acima para entrar.
      Recomendamos que você altere sua senha após o primeiro acesso
      por meio da opção "Redefinir Senha" disponível no sistema.

      Atenciosamente,
      Equipe CAMAAR — Universidade de Brasília

    EMAIL
  end
end
