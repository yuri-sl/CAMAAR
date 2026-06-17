class CreateTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :templates do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :templates, :name, unique: true

    add_column :formularios, :template_id, :integer
    add_index :formularios, :template_id
    add_foreign_key :formularios, :templates, column: :template_id
  end
end
