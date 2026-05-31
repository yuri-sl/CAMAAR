class CreateFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :formularios do |t|
      t.string :nome_formulario
      t.float :nota_final
      t.float :nota_media
      t.boolean :publico_estudante
      t.references :template_formulario, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.references :criador_formulario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
