class CreateTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :turmas, if_not_exists: true do |t|
      t.string :name, null: false
      t.string :codigo, null: false
      t.string :semester, null: false
      t.references :department, null: false, foreign_key: true
      t.timestamps
    end
  end
end
