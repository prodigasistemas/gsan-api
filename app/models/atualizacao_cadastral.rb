class AtualizacaoCadastral < ActiveRecord::Base
  include IncrementableId
  include API::Filterable
  include API::Model

  self.table_name  = 'seguranca.tab_atlz_cadastral'
  self.primary_key = 'tatc_id'

  alias_attribute :id,                         :tatc_id
  alias_attribute :tabela_id,                  :tabe_id
  alias_attribute :leiturista_id,              :leit_id
  alias_attribute :arquivo_texto_atlz_cad_id,  :txac_id
  alias_attribute :codigo_imovel,              :tatc_cdimovel
  alias_attribute :codigo_cliente,             :tatc_cdcliente
  alias_attribute :complemento,                :tatc_complemento
  alias_attribute :tipo_alteracao,             :altp_id

  has_many :coluna_atualizacao_cadastrais, foreign_key: :tatc_id

  SIM = "1"
  NAO = "2"
  EXIBIR_IMOVEL = { todos: "-1", pendentes: "-3", pre_aprovados: "7", aprovar_em_lote: "-2" }.freeze
  TODOS = "-1"
  SEM_CPF = "-2"

  PARAMETROS_OCORRENCIA = { alteracao_hidrometro: "'imac_nnhidrometro'",
                            alteracao_agua: "'last_id'",
                            alteracao_esgoto: "'lest_id'",
                            alteracao_categoria_subcategoria: "'isac_qteconomia'",
                            alteracao_cpf: "'clac_nncpfcnpj'" }

  def self.buscar_atualizacoes_para_recadastramento(params)
    query = <<-SQL
      select
        distinct tatc.tatc_cdimovel as codigo_imovel,
        us.usur_nmusuario as agente_cadastral,
        tatc.altp_id as tipo_alteracao,
        replace(siac.siac_dssituacao, '_', ' ') as situacao
      from seguranca.tab_atlz_cadastral tatc
      inner join seguranca.tab_col_atlz_cadastral tcac on  tatc.tatc_id = tcac.tatc_id
      inner join seguranca.tabela_coluna tbco on tbco.tbco_id = tcac.tbco_id
      inner join cadastro.arquivo_texto_atlz_cad txac on tatc.txac_id = txac.txac_id
      inner join micromedicao.rota rota on rota.rota_id = txac.rota_id
      inner join micromedicao.leiturista leiturista on leiturista.leit_id = tatc  .leit_id
      left join atualizacaocadastral.imovel_controle_atlz_cad ctrl on ctrl.imov_id = tatc.tatc_cdimovel or ctrl.icac_id = tatc.tatc_cdimovel
      left join cadastro.situacao_atlz_cadastral siac on siac.siac_id = ctrl.siac_id
      left join cadastro.imovel_atlz_cadastral im on im.imov_id = tatc.tatc_cdimovel
      left join cadastro.cadastro_ocorrencia cocr on cocr.cocr_id = ctrl.cocr_id
      left join atualizacaocadastral.visita vis on vis.icac_id = ctrl.icac_id
      left join seguranca.usuario us on us.usur_id = vis.usur_id
      where 1 = 1
      and vis.vist_id = (select max(v2.vist_id) from atualizacaocadastral.visita v2 where v2.icac_id = ctrl.icac_id)
    SQL
    query << "and leiturista.empr_id = #{params[:empresa_id]}" unless params[:empresa_id].blank?
    query << "\nand ctrl.siac_id not in (#{SituacaoAtualizacaoCadastral::SITUACOES[:"EM CORRECAO"]})"
    query << "\nand tatc.tatc_cdimovel = #{params[:matricula]}" unless params[:matricula].blank?

    unless params[:leiturista_id].blank?
      query << "\nand vis.usur_id = (select usur.usur_id from micromedicao.leiturista leit "
      query << "\ninner join cadastro.funcionario func on leit.func_id = func.func_id"
      query << "\ninner join seguranca.usuario usur on usur.usur_nncpf = func.func_nncpf"
      query << "\nwhere leit.leit_id = #{params[:leiturista_id]} limit 1)"
    end


    unless params[:periodo_inicial].blank? or params[:periodo_final].blank?
      query << "\nand ctrl.icac_tmretorno::Date between '#{params[:periodo_inicial].try(:to_date).try(:strftime)}' and "
      query << "'#{params[:periodo_final].try(:to_date).try(:strftime)}'"
    end
    unless params[:localidade_id_inicial].blank? or params[:localidade_id_final].blank?
      query << "\nand txac.loca_id between #{params[:localidade_id_inicial]} and #{params[:localidade_id_final]}"
    end
    unless params[:setor_comercial_id_inicial].blank? or params[:setor_comercial_id_final].blank?
      query << "\nand rota.stcm_id between #{params[:setor_comercial_id_inicial]} and #{params[:setor_comercial_id_final]}"
    end
    unless params[:rota_id_inicial].blank? or params[:rota_id_final].blank?
      query << "\nand rota.rota_cdrota between #{params[:rota_id_inicial]} and #{params[:rota_id_final]}"
    end

    situacoes = ""
    if !params[:exibir_imoveis].blank? and params[:exibir_imoveis] != EXIBIR_IMOVEL[:todos]
      if params[:exibir_imoveis] == EXIBIR_IMOVEL[:aprovar_em_lote]
        query << "\nand cocr.cocr_icvalidacao = #{SIM}"
        situacoes = "#{SituacaoAtualizacaoCadastral::SITUACOES[:"TRANSMITIDO"]}"
      else
        situacoes = "#{params[:exibir_imoveis].to_i.abs}" unless 
        if params[:exibir_imoveis] == EXIBIR_IMOVEL[:pendentes]
          situacoes << ", " unless situacoes.blank?
          situacoes << " #{SituacaoAtualizacaoCadastral::SITUACOES[:"EM REVISAO"]}, #{SituacaoAtualizacaoCadastral::SITUACOES[:"REVISITA"]}"
        end
      end
    end

    query << "\nand ctrl.siac_id in (#{situacoes})" unless situacoes.blank?

    if params[:ocorrencias_cadastro].present? and
        params[:ocorrencias_cadastro] != TODOS and
        params[:exibir_imoveis] != EXIBIR_IMOVEL[:aprovar_em_lote]
      query << "\nand cocr.cocr_icvalidacao = #{params[:ocorrencias_cadastro]}"
      query << "\nand cocr.cocr_id = #{params[:cadastro_ocorrencia_id]}" if params[:cadastro_ocorrencia_id].present?
    end

    if params[:quantidade_visitas].present?
      query << "\nand #{params[:quantidade_visitas]} = (select count(vist_id) from atualizacaocadastral.visita where icac_id = ctrl.icac_id)"
    end

    resultado = ActiveRecord::Base.connection.execute("#{query}\norder by tatc.tatc_cdimovel")
    PARAMETROS_OCORRENCIA.keys.each { |k| params[k] = "2"} if params[:exibir_imoveis] == EXIBIR_IMOVEL[:aprovar_em_lote]
    resultado = tratar_ocorrencias(query, resultado, params) unless params[:exibir_imoveis] == EXIBIR_IMOVEL[:todos]
    unless params[:alteracao_cpf].blank? or params[:alteracao_cpf] == TODOS
      resultado = filtrar_imoveis_quanto_a_alteracao_de_cpf(query, resultado, params[:alteracao_cpf] == NAO)
    end
    unless params[:cpf_ja_cadastrado].blank? or params[:cpf_ja_cadastrado] == TODOS
      resultado = filtrar_imoveis_quanto_a_cpf_ja_cadastrado(query, resultado, params[:cpf_ja_cadastrado] == SIM) 
    end
    resultado
  end

  def self.concatenar_subquery_aprovar_em_lote(query)
    query_imoveis = query.gsub(",
        func.func_nmfuncionario as agente_cadastral,
        siac.siac_dssituacao as situacao", "")
    colunas = PARAMETROS_OCORRENCIA.keys.map {|k| PARAMETROS_OCORRENCIA[k]}.join(',')
    query_imoveis << "\nand lower(tbco.tbco_nmcoluna) in (#{colunas}) group by tatc.tatc_cdimovel"
    "#{query}\nand tatc.tatc_cdimovel not in (#{query_imoveis})"
  end

  def self.tratar_ocorrencias(query, imoveis, params)
    imoveis_filtrados = imoveis
    PARAMETROS_OCORRENCIA.keys.each do |chave|
      if params[chave].present? and params[chave].to_i > TODOS.to_i
        imoveis_filtrados = remover_imoveis(imoveis_filtrados,
                      query_ocorrencia(query, PARAMETROS_OCORRENCIA[chave]),
                      params[chave] == NAO)
      end
    end
    imoveis_filtrados
  end

  def self.query_ocorrencia(query, coluna)
    ActiveRecord::Base.connection.execute("#{query}\nand lower(tbco.tbco_nmcoluna) = lower(#{coluna})\norder by tatc.tatc_cdimovel")
  end

  def self.remover_imoveis(imoveis, imovel_ocorrencias, invertido)
    invertido ? (imoveis.to_a - imovel_ocorrencias.to_a) : (imoveis.to_a & imovel_ocorrencias.to_a)
  end

  def self.filtrar_imoveis_quanto_a_alteracao_de_cpf(query, todos_imoveis, sem_alteracao)
    imoveis_alteracao_cpf = remover_imoveis(todos_imoveis, 
                                            query_ocorrencia(query, PARAMETROS_OCORRENCIA[:alteracao_cpf]), 
                                            sem_alteracao)
  end

  def self.filtrar_imoveis_quanto_a_cpf_ja_cadastrado(query, todos_imoveis, ja_cadastrado)
    imoveis_cadastrados = ActiveRecord::Base.connection.execute(query.gsub("where 1 = 1", query_client_cpf(ja_cadastrado)))
    remover_imoveis(todos_imoveis, imoveis_cadastrados, false)
  end

  private
    def self.query_client_cpf(ja_cadastrado)
      query_join = "left join cadastro.cliente_atlz_cadastral cliente on cliente.imov_id = tatc.tatc_cdimovel"
      query_join << "\nwhere 1 = 1"
      query_join << "\nand cliente.clac_nncpfcnpj is #{ja_cadastrado ? 'not ' : ''}null"
    end
end
