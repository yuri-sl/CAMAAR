class Template < ApplicationRecord
  has_many :formularios, dependent: :nullify
  validates :name, presence: true, uniqueness: true
end
