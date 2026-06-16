require 'rails_helper'

RSpec.describe "SenhaController", type: :request do
  let(:usuario) { create(:usuario, password: 'oldpass') }

  before do
    post login_path, params: { email: usuario.email, password: 'oldpass' }
    follow_redirect!
  end

  describe "POST /senha/redefinir" do
    context "Com senha antiga correta e as duas novas senhas iguais" do
      it "updates password and shows no alert" do
        post senha_redefinir_path, params: {
          password: 'oldpass',
          new_password_1: 'newpass',
          new_password_2: 'newpass'
        }
        expect(flash[:alert]).to be_nil
        expect(usuario.reload.authenticate('newpass')).to be_truthy
      end
    end

    context "Com senha errada" do
      it "Manda um aviso e não muda a senha" do
        post senha_redefinir_path, params: {
          password: 'wrong',
          new_password_1: 'newpass',
          new_password_2: 'newpass'
        }
        expect(flash[:alert]).to eq("Senha antiga está incorreta")
        expect(usuario.reload.authenticate('oldpass')).to be_truthy
      end
    end

    context "Novas senhas diferentes" do
      it "sets alert and does not change password" do
        post senha_redefinir_path, params: {
          password: 'oldpass',
          new_password_1: 'newpass',
          new_password_2: 'mismatch'
        }
        expect(flash[:alert]).to eq("As senhas não são as mesmas")
        expect(usuario.reload.authenticate('oldpass')).to be_truthy
      end
    end
  end
end
