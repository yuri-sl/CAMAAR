class CreateTurmas < ActiveRecord::Migration[8.1]
  def up
    if table_exists?(:turmas)
      unless column_exists?(:turmas, :department_id)
        add_column :turmas, :department_id, :integer
      end
      unless index_exists?(:turmas, :department_id)
        add_index :turmas, :department_id
      end
      unless foreign_key_exists?(:turmas, :departments)
        add_foreign_key :turmas, :departments
      end
    else
      create_table :turmas do |t|
        t.string :name, null: false
        t.string :codigo, null: false
        t.string :semester, null: false
        t.references :department, null: false, foreign_key: true
        t.timestamps
      end
    end
  end

  def down
    drop_table :turmas, if_exists: true
  end
end
