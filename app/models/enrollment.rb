class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :turma

  validates :user_id, uniqueness: { scope: :turma_id }
end
