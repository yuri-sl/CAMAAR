class RenamePerguntumToPergunta < ActiveRecord::Migration[8.1]
  def change
    rename_table :pergunta, :pergunta
  end
end
