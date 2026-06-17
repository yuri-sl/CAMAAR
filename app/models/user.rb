class User < ApplicationRecord
  has_secure_password

  enum :role, { student: 0, admin: 1, coordinator: 2 }

  belongs_to :department, optional: true
  has_many :enrollments, dependent: :destroy
  has_many :turmas, through: :enrollments
  has_many :respostas, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true
end
