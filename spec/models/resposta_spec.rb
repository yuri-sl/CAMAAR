require "rails_helper"

RSpec.describe Resposta, type: :model do
  describe "validations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:formulario) }
    it { is_expected.to belong_to(:turma) }
  end

  describe "uniqueness" do
    it "prevents a student from submitting the same form twice for the same class" do
      department = create(:department)
      turma = create(:turma, department: department)
      formulario = create(:formulario, department: department)
      student = create(:user, department: department)

      create(:resposta, user: student, formulario: formulario, turma: turma)
      duplicate = build(:resposta, user: student, formulario: formulario, turma: turma)

      expect(duplicate).not_to be_valid
    end
  end

  describe "#set_submitted_at" do
    it "sets submitted_at automatically on creation" do
      department = create(:department)
      turma = create(:turma, department: department)
      formulario = create(:formulario, department: department)
      student = create(:user, department: department)

      resposta = Resposta.create!(
        user: student,
        formulario: formulario,
        turma: turma
      )

      expect(resposta.submitted_at).not_to be_nil
    end
  end
end
