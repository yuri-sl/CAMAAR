class Usuario < ApplicationRecord
  has_secure_password

  enum :role, {
    admin: 0,
    professor: 1,
    estudante: 2
  }
  has_one :professor
  has_one :admin
  has_one :estudante
  has_one :criador_formulario

  has_many :resposta_formularios

  before_save { self.email = email.downcase.strip }

  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true
end
