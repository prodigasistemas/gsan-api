class HidrometroInstalacaoHistorico < ActiveRecord::Base
  include IncrementableId
  include API::Filterable
  include API::Model

  self.table_name  = 'micromedicao.hidrometro_inst_hist'
  self.primary_key = 'hidi_id'

  alias_attribute "id", "hidi_id"
  alias_attribute "hidrometro_id", "hidr_id"
  alias_attribute "data_instalacao", "hidi_dtinstalacaohidrometro"
  alias_attribute "tipo_medicao_id", "medt_id"
  alias_attribute "rateio_tipo_id", "rttp_id"
  alias_attribute "local_instalacao_id", "hili_id"
  alias_attribute "protecao_hidrometro_id", "hipr_id"
  alias_attribute "numero_leitura_instalacao", "hidi_nnleitinstalacaohidmt"
  alias_attribute "data_retirada", "hidi_dtretiradahidrometro"
  alias_attribute "numero_leitura_retirada", "hidi_nnleitretiradahidmt"
  alias_attribute "data_instalacao_sistema", "hidi_dtinstalacaohidmtsistema"
  alias_attribute "numero_leitura_corte", "hidi_nnleituracorte"
  alias_attribute "indicador_cavalete", "hidi_iccavalete"
  alias_attribute "indicador_instalacao_substituicao", "hidi_icinstalacaosubstituicao"
  alias_attribute "numero_leitura_supressao", "hidi_nnleiturasupressao"
  alias_attribute "ultima_alteracao", "hidi_tmultimaalteracao"
  alias_attribute "imovel_id", "imov_id"
  alias_attribute "ligacao_agua_id", "lagu_id"
  alias_attribute "numero_selo", "hidi_nnselo"
  alias_attribute "indicador_troca_protecao", "hidi_ictrocaprotecao"
  alias_attribute "indicador_troca_registro", "hidi_ictrocaregistro"
  alias_attribute "usuario_instalacao_id", "usur_idinstalacao"
  alias_attribute "usuario_retirada_id", "usur_idretirada"
  alias_attribute "numero_lacre", "hidi_nnlacre"
end