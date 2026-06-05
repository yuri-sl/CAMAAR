class PagesController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: :gerenciamento

  def gerenciamento; end
  def avaliacoes; end
  def relatorios; end
end