require 'rails_helper'

describe FoneTiposController, type: :controller do
  render_views

  let!(:comercial)          { create(:fone_tipo, descricao: 'COMERCIAL') }
  let!(:residencial)        { create(:fone_tipo, descricao: 'RESIDENCIAL') }

  describe "GET index" do
    context "quando a consulta não possuir filtros" do
      before do
        get :index, nil, format: :json
      end

      it "retorna a lista de tipos de telefone" do
        expect(json.size).to eq 2
        expect(json.collect{|l| l["descricao"]}).to include(comercial.descricao)
      end
    end
  end
end