class CreateRespostaQuestoes < ActiveRecord::Migration[8.1]
  def change
    create_table :resposta_questoes do |t|
      t.bigint :resposta_id, null: false
      t.bigint :questao_id, null: false
      t.text :answer
      t.timestamps
    end
    add_index :resposta_questoes, :resposta_id
    add_index :resposta_questoes, :questao_id
    add_index :resposta_questoes, [:resposta_id, :questao_id], unique: true
    add_foreign_key :resposta_questoes, :respostas, column: :resposta_id
    add_foreign_key :resposta_questoes, :questoes,  column: :questao_id
  end
end
