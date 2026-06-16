class Department < ApplicationRecord
  has_many :users
  has_many :turmas
  has_many :formularios

  validates :name, presence: true, uniqueness: true
end
