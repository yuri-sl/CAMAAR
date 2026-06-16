require "rails_helper"

RSpec.describe TurmaFormulario, type: :model do
  describe "validations" do
    it { is_expected.to belong_to(:turma) }
    it { is_expected.to belong_to(:formulario) }
  end

  describe "uniqueness" do
    it "prevents the same form from being associated twice to the same class" do
      department = create(:department)
      turma = create(:turma, department: department)
      formulario = create(:formulario, department: department)

      create(:turma_formulario, turma: turma, formulario: formulario)
      duplicate = build(:turma_formulario, turma: turma, formulario: formulario)

      expect(duplicate).not_to be_valid
    end

    it "allows the same form to be associated with different classes" do
      department = create(:department)
      turma1 = create(:turma, department: department)
      turma2 = create(:turma, department: department)
      formulario = create(:formulario, department: department)

      create(:turma_formulario, turma: turma1, formulario: formulario)
      second = build(:turma_formulario, turma: turma2, formulario: formulario)

      expect(second).to be_valid
    end
  end
end
