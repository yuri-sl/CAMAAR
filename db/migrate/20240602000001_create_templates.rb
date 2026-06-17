class CreateTemplates < ActiveRecord::Migration[8.1]
  def up
    if table_exists?(:templates)
      add_column :templates, :name, :string unless column_exists?(:templates, :name)
      add_timestamps :templates, null: true unless column_exists?(:templates, :created_at)
    else
      create_table :templates do |t|
        t.string :name, null: false
        t.timestamps
      end
    end

    add_index :templates, :name, unique: true unless index_exists?(:templates, :name)

    add_column :formularios, :template_id, :integer unless column_exists?(:formularios, :template_id)
    add_index :formularios, :template_id unless index_exists?(:formularios, :template_id)
    unless foreign_key_exists?(:formularios, :templates, column: :template_id)
      add_foreign_key :formularios, :templates, column: :template_id
    end
  end

  def down
    remove_foreign_key :formularios, column: :template_id if foreign_key_exists?(:formularios, :templates, column: :template_id)
    remove_index :formularios, :template_id if index_exists?(:formularios, :template_id)
    remove_column :formularios, :template_id if column_exists?(:formularios, :template_id)
    drop_table :templates, if_exists: true
  end
end
