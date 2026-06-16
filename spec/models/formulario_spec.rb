require "rails_helper"

RSpec.describe Formulario, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:deadline) }
    it { is_expected.to belong_to(:department) }
    it { is_expected.to belong_to(:created_by) }
    it { is_expected.to have_many(:questoes) }
    it { is_expected.to have_many(:respostas) }
    it { is_expected.to have_many(:turma_formularios) }
  end

  describe "#expired?" do
    it "returns true when deadline has passed" do
      formulario = build(:formulario, deadline: 1.day.ago)
      expect(formulario.expired?).to be true
    end

    it "returns false when deadline is in the future" do
      formulario = build(:formulario, deadline: 1.day.from_now)
      expect(formulario.expired?).to be false
    end
  end

  describe "#has_responses?" do
    let(:formulario) { create(:formulario) }

    it "returns false when no responses exist" do
      expect(formulario.has_responses?).to be false
    end

    it "returns true when responses exist" do
      turma = create(:turma, department: formulario.department)
      student = create(:user, department: formulario.department)
      create(:resposta, formulario: formulario, turma: turma, user: student)
      expect(formulario.has_responses?).to be true
    end
  end
end
