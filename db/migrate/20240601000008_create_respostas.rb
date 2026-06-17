class CreateRespostas < ActiveRecord::Migration[8.1]
  def up
    if table_exists?(:respostas)
      add_column :respostas, :user_id, :integer unless column_exists?(:respostas, :user_id)
      add_column :respostas, :formulario_id, :integer unless column_exists?(:respostas, :formulario_id)
      add_column :respostas, :turma_id, :integer unless column_exists?(:respostas, :turma_id)
      add_column :respostas, :submitted_at, :datetime unless column_exists?(:respostas, :submitted_at)
      add_timestamps :respostas, null: true unless column_exists?(:respostas, :created_at)
    else
      create_table :respostas do |t|
        t.references :user, null: false, foreign_key: true
        t.references :formulario, null: false, foreign_key: true
        t.references :turma, null: false, foreign_key: true
        t.datetime :submitted_at, null: false
        t.timestamps
      end
    end

    unless index_exists?(:respostas, :user_id)
      add_index :respostas, :user_id
    end
    unless index_exists?(:respostas, :formulario_id)
      add_index :respostas, :formulario_id
    end
    unless index_exists?(:respostas, :turma_id)
      add_index :respostas, :turma_id
    end
    unless index_exists?(:respostas, [:user_id, :formulario_id, :turma_id])
      add_index :respostas, [:user_id, :formulario_id, :turma_id], unique: true
    end
    unless foreign_key_exists?(:respostas, :users)
      add_foreign_key :respostas, :users
    end
    unless foreign_key_exists?(:respostas, :formularios)
      add_foreign_key :respostas, :formularios
    end
    unless foreign_key_exists?(:respostas, :turmas)
      add_foreign_key :respostas, :turmas
    end
  end

  def down
    drop_table :respostas, if_exists: true
  end
end
