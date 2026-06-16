class AddDetalhesToPerguntaFormularios < ActiveRecord::Migration[8.1]
  def change
    add_column :pergunta_formularios, :tipo_pergunta, :integer
    add_column :pergunta_formularios, :enunciado, :text
    add_column :pergunta_formularios, :numero_opcoes, :integer
    add_column :pergunta_formularios, :opcoes_radio, :json
    add_column :pergunta_formularios, :gabarito_radio, :integer
    add_column :pergunta_formularios, :gabarito_discursiva, :text
  end
end
