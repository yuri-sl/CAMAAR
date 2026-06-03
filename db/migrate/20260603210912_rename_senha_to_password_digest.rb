class RenameSenhaToPasswordDigest < ActiveRecord::Migration[8.1]
  def change
    remove_column :usuarios, :senha, :string
  end
end