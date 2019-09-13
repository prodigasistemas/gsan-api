class Atendimento::DadosAdicionaisController < ImoveisController

  private 

  def busca_imovel
    @imovel = Atendimento::DadoAdicional.com_escopo([:logradouro]).find(params[:id]) 
  end

  def inclusoes
    super << :dados_adicionais
  end  
end