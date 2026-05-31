class CreateTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :turmas do |t|
      t.integer :numero_turma
      t.string :semestre_string
      t.float :nota_turma
      t.references :materia, null: false, foreign_key: true
      t.references :professor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
