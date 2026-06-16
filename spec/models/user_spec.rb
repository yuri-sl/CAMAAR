require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to have_many(:enrollments) }
    it { is_expected.to have_many(:respostas) }
  end

  describe "email uniqueness" do
    it "rejects duplicate emails" do
      create(:user, email: "test@example.com")
      duplicate = build(:user, email: "test@example.com")
      expect(duplicate).not_to be_valid
    end
  end

  describe "roles" do
    it "can be student" do
      user = build(:user, role: :student)
      expect(user.student?).to be true
    end

    it "can be admin" do
      user = build(:user, :admin)
      expect(user.admin?).to be true
    end

    it "can be coordinator" do
      user = build(:user, :coordinator)
      expect(user.coordinator?).to be true
    end
  end

  describe "authentication" do
    it "authenticates with correct password" do
      user = create(:user, password: "secret123", password_confirmation: "secret123")
      expect(user.authenticate("secret123")).to eq(user)
    end

    it "rejects wrong password" do
      user = create(:user, password: "secret123", password_confirmation: "secret123")
      expect(user.authenticate("wrong")).to be false
    end
  end
end
