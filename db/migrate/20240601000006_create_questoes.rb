class CreateQuestoes < ActiveRecord::Migration[8.1]
  def change
    create_table :questoes do |t|
      t.references :formulario, null: false, foreign_key: true
      t.text :enunciado, null: false
      t.boolean :required, null: false, default: true
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
