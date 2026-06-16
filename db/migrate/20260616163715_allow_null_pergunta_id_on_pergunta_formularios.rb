class AllowNullPerguntaIdOnPerguntaFormularios < ActiveRecord::Migration[8.1]
  def change
    change_column_null :pergunta_formularios, :pergunta_id, true
  end
end
