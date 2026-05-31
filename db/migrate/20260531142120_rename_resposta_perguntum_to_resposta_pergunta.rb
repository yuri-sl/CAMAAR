class RenameRespostaPerguntumToRespostaPergunta < ActiveRecord::Migration[8.1]
  def change
    rename_table :resposta_pergunta, :resposta_pergunta
  end
end
