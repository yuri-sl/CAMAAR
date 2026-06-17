class CreateTurmaFormularios < ActiveRecord::Migration[8.1]
  def up
    if table_exists?(:turma_formularios)
      add_column :turma_formularios, :turma_id, :integer unless column_exists?(:turma_formularios, :turma_id)
      add_column :turma_formularios, :formulario_id, :integer unless column_exists?(:turma_formularios, :formulario_id)
      add_timestamps :turma_formularios, null: true unless column_exists?(:turma_formularios, :created_at)
    else
      create_table :turma_formularios do |t|
        t.references :turma, null: false, foreign_key: true
        t.references :formulario, null: false, foreign_key: true
        t.timestamps
      end
    end

    unless index_exists?(:turma_formularios, :turma_id)
      add_index :turma_formularios, :turma_id
    end
    unless index_exists?(:turma_formularios, :formulario_id)
      add_index :turma_formularios, :formulario_id
    end
    unless index_exists?(:turma_formularios, [:turma_id, :formulario_id])
      add_index :turma_formularios, [:turma_id, :formulario_id], unique: true
    end
    unless foreign_key_exists?(:turma_formularios, :turmas)
      add_foreign_key :turma_formularios, :turmas
    end
    unless foreign_key_exists?(:turma_formularios, :formularios)
      add_foreign_key :turma_formularios, :formularios
    end
  end

  def down
    drop_table :turma_formularios, if_exists: true
  end
end
