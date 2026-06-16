class CreateFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :formularios do |t|
      t.string :title, null: false
      t.text :description
      t.integer :created_by_id, null: false
      t.references :department, null: false, foreign_key: true
      t.datetime :deadline, null: false
      t.timestamps
    end
    add_foreign_key :formularios, :users, column: :created_by_id
  end
end
