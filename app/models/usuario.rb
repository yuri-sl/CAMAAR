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

  before_validation :normalize_email

  validates :nome, presence: { message: "é obrigatório" }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "é inválido" }
  validates :password_confirmation, presence: { message: "é obrigatória" }, on: :create
  validate :password_meets_complexity_requirements

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end

  def password_meets_complexity_requirements
    return if password.blank?
    return if password.length >= 8 && password.match?(/[A-Za-z]/) && password.match?(/\d/)

    errors.add(:password, "deve ter no mínimo 8 caracteres, incluindo letras e números")
  end
end
