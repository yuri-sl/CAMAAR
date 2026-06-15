class AjustarEsquemaDePergunta < ActiveRecord::Migration[8.1]
  def change
    add_column :pergunta, :enunciado, :text
    
    add_column :pergunta, :numero_opcoes, :integer

    remove_column :pergunta, :gabarito_radio
    add_column :pergunta, :gabarito_radio, :integer

    remove_column :pergunta, :opcoes_radio
    add_column :pergunta, :opcoes_radio, :json
  end
end
