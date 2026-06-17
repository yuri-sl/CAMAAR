class CreateQuestoes < ActiveRecord::Migration[8.1]
  def up
    if table_exists?(:questoes)
      add_column :questoes, :formulario_id, :integer unless column_exists?(:questoes, :formulario_id)
      add_column :questoes, :enunciado, :text unless column_exists?(:questoes, :enunciado)
      add_column :questoes, :required, :boolean, default: true unless column_exists?(:questoes, :required)
      add_column :questoes, :position, :integer, default: 0 unless column_exists?(:questoes, :position)
      add_timestamps :questoes, null: true unless column_exists?(:questoes, :created_at)
    else
      create_table :questoes do |t|
        t.references :formulario, null: false, foreign_key: true
        t.text :enunciado, null: false
        t.boolean :required, null: false, default: true
        t.integer :position, null: false, default: 0
        t.timestamps
      end
    end

    unless index_exists?(:questoes, :formulario_id)
      add_index :questoes, :formulario_id
    end
    unless foreign_key_exists?(:questoes, :formularios)
      add_foreign_key :questoes, :formularios
    end
  end

  def down
    drop_table :questoes, if_exists: true
  end
end
