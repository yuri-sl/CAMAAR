class CreateTurmaFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :turma_formularios do |t|
      t.references :turma, null: false, foreign_key: true
      t.references :formulario, null: false, foreign_key: true
      t.timestamps
    end
    add_index :turma_formularios, [:turma_id, :formulario_id], unique: true
  end
end
