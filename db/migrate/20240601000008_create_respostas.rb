class CreateRespostas < ActiveRecord::Migration[8.1]
  def change
    create_table :respostas do |t|
      t.references :user, null: false, foreign_key: true
      t.references :formulario, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.datetime :submitted_at, null: false
      t.timestamps
    end
    add_index :respostas, [:user_id, :formulario_id, :turma_id], unique: true
  end
end
