class CreateFormularios < ActiveRecord::Migration[8.1]
  def up
    if table_exists?(:formularios)
      add_column :formularios, :title, :string unless column_exists?(:formularios, :title)
      add_column :formularios, :description, :text unless column_exists?(:formularios, :description)
      add_column :formularios, :created_by_id, :integer unless column_exists?(:formularios, :created_by_id)
      add_column :formularios, :department_id, :integer unless column_exists?(:formularios, :department_id)
      add_column :formularios, :deadline, :datetime unless column_exists?(:formularios, :deadline)
      add_timestamps :formularios, null: true unless column_exists?(:formularios, :created_at)
    else
      create_table :formularios do |t|
        t.string :title, null: false
        t.text :description
        t.integer :created_by_id, null: false
        t.references :department, null: false, foreign_key: true
        t.datetime :deadline, null: false
        t.timestamps
      end
    end

    unless index_exists?(:formularios, :department_id)
      add_index :formularios, :department_id
    end
    unless foreign_key_exists?(:formularios, :departments)
      add_foreign_key :formularios, :departments
    end
    unless foreign_key_exists?(:formularios, :users, column: :created_by_id)
      add_foreign_key :formularios, :users, column: :created_by_id
    end
  end

  def down
    drop_table :formularios, if_exists: true
  end
end
