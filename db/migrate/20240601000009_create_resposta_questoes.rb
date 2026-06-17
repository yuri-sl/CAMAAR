class CreateRespostaQuestoes < ActiveRecord::Migration[8.1]
  def up
    if table_exists?(:resposta_questoes)
      add_column :resposta_questoes, :resposta_id, :bigint unless column_exists?(:resposta_questoes, :resposta_id)
      add_column :resposta_questoes, :questao_id, :bigint unless column_exists?(:resposta_questoes, :questao_id)
      add_column :resposta_questoes, :answer, :text unless column_exists?(:resposta_questoes, :answer)
      add_timestamps :resposta_questoes, null: true unless column_exists?(:resposta_questoes, :created_at)
    else
      create_table :resposta_questoes do |t|
        t.bigint :resposta_id, null: false
        t.bigint :questao_id, null: false
        t.text :answer
        t.timestamps
      end
    end

    add_index :resposta_questoes, :resposta_id unless index_exists?(:resposta_questoes, :resposta_id)
    add_index :resposta_questoes, :questao_id unless index_exists?(:resposta_questoes, :questao_id)
    unless index_exists?(:resposta_questoes, [:resposta_id, :questao_id])
      add_index :resposta_questoes, [:resposta_id, :questao_id], unique: true
    end
    unless foreign_key_exists?(:resposta_questoes, :respostas, column: :resposta_id)
      add_foreign_key :resposta_questoes, :respostas, column: :resposta_id
    end
    unless foreign_key_exists?(:resposta_questoes, :questoes, column: :questao_id)
      add_foreign_key :resposta_questoes, :questoes, column: :questao_id
    end
  end

  def down
    drop_table :resposta_questoes, if_exists: true
  end
end
