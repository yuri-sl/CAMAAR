class AddDetalhesToPerguntaFormularios < ActiveRecord::Migration[8.1]
  def change
    add_column :pergunta_formularios, :tipo_pergunta, :integer
    add_column :pergunta_formularios, :enunciado, :text
    add_column :pergunta_formularios, :numero_opcoes, :integer
    add_column :pergunta_formularios, :opcoes_radio, :json
    add_column :pergunta_formularios, :gabarito_radio, :integer
    add_column :pergunta_formularios, :gabarito_discursiva, :text

    # Remove a FK existente ANTES de recriar a tabela. Em bancos antigos ela
    # aponta (erroneamente) para :perguntas; em bancos criados já com a migration
    # corrigida, para :pergunta. Removendo ambas as possibilidades evitamos que o
    # change_column_null recrie a tabela copiando uma FK para tabela inexistente.
    remove_foreign_key :pergunta_formularios, :perguntas, if_exists: true
    remove_foreign_key :pergunta_formularios, :pergunta, if_exists: true

    change_column_null :pergunta_formularios, :pergunta_id, true

    add_foreign_key :pergunta_formularios, :pergunta, column: :pergunta_id, on_delete: :nullify
  end
end
