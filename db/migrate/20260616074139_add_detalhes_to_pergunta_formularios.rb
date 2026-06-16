class AddDetalhesToPerguntaFormularios < ActiveRecord::Migration[8.1]
  def change
    add_column :pergunta_formularios, :tipo_pergunta, :integer
    add_column :pergunta_formularios, :enunciado, :text
    add_column :pergunta_formularios, :numero_opcoes, :integer
    add_column :pergunta_formularios, :opcoes_radio, :json
    add_column :pergunta_formularios, :gabarito_radio, :integer
    add_column :pergunta_formularios, :gabarito_discursiva, :text

    change_column_null :pergunta_formularios, :pergunta_id, true

    remove_foreign_key :pergunta_formularios, :perguntas, if_exists: true
    add_foreign_key :pergunta_formularios, :perguntas, on_delete: :nullify
  end
end
