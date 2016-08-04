class ImovelRetorno < ActiveRecord::Base
  include IncrementableId
  include API::Filterable
  include API::Model

  self.table_name  = 'atualizacaocadastral.imovel_retorno'
  self.primary_key = 'imre_id'

  alias_attribute "id", "imre_id"

  alias_attribute "numero_imovel", "imac_nnimovel"
  alias_attribute "complemento_endereco", "imac_dscomplementoendereco"
  alias_attribute "pontos_utilizacao", "imac_nnpontosutilizacao"
  alias_attribute "numero_moradores", "imac_nnmorador"
  alias_attribute "iptu", "imac_nniptu"
  alias_attribute "coordenada_x", "imac_nncoordenadax"
  alias_attribute "coordenada_y", "imac_nncoordenaday"
  alias_attribute "numero_hidrometro", "imac_nnhidrometro"
  alias_attribute "numero_medidor_energia", "imac_nnmedidorenergia"
  alias_attribute "outras_informacoes", "imac_dsoutrasinformacoes"
  alias_attribute "tipo_entrevistado", "imac_tipoentrevistado"
  alias_attribute "tipo_operacao", "imac_tipooperacao"
  alias_attribute "ultima_alteracao", "imac_tmultimaalteracao"
  alias_attribute "ligacao_agua_situacao_id", "last_id"
  alias_attribute "fonte_abastecimento_id", "ftab_id"
  alias_attribute "hidrometro_protecao_id", "hipr_id"
  alias_attribute "imovel_id", "imov_id"
  alias_attribute "municipio_id", "muni_id"
  alias_attribute "municipio", "imac_nmmunicipio"
  alias_attribute "logradouro_tipo_id", "lgtp_id"
  alias_attribute "logradouro_id", "logr_id"
  alias_attribute "descricao_logradouro", "imac_dslogradouro"
  alias_attribute "nome_bairro", "imac_nmbairro"
  alias_attribute "codigo_cep", "imac_cdcep"
  alias_attribute "localidade_id", "loca_id"
  alias_attribute "codigo_setor_comercial", "imre_cdsetorcomercial"
  alias_attribute "numero_quadra", "imre_nnquadra"
  alias_attribute "ligacao_esgoto_situacao_id", "lest_id"
  alias_attribute "ramal_local_instalacao_id", "rlin_id"
  alias_attribute "hidrometro_marca_id", "himc_id"
  alias_attribute "hidrometro_capacidade_id", "hicp_id"
  alias_attribute "classe_social", "imre_classe_social"
  alias_attribute "quantidade_animais_domesticos", "imre_quantidade_animais_domesticos"
  alias_attribute "volume_cisterna", "imre_vol_cisterna"
  alias_attribute "volume_caixa_dagua", "imre_vol_cx_dagua"
  alias_attribute "tipo_uso", "imre_tipo_uso"
  alias_attribute "acesso_hidrometro", "imre_acesso_hidrometro"
  alias_attribute "quantidade_economias_social", "imre_qtd_economias_social"
  alias_attribute "quatidade_economias_outra", "imre_qtd_economias_outra"

  belongs_to :imovel, foreign_key: "imov_id"
  belongs_to :municipio, foreign_key: "muni_id"
  belongs_to :logradouro_tipo, foreign_key: "lgtp_id"
  belongs_to :logradouro, foreign_key: "logr_id"
  belongs_to :localidade, foreign_key: "loca_id"
  belongs_to :ligacao_agua_situacao, foreign_key: "last_id"
  belongs_to :fonte_abastecimento, foreign_key: "ftab_id"
  belongs_to :ligacao_esgoto_situacao, foreign_key: "lest_id"
  belongs_to :ramal_local_instalacao_id, foreign_key: "rlin_id"
  belongs_to :hidrometro_protecao, "foreign_key": "hipr_id"
  belongs_to :hidrometro_marca, foreign_key: "himc_id"
  belongs_to :hidrometro_capacidade, foreign_key: "hicp_id"

  has_many :cliente_imovel_retornos
  has_many :cliente_retornos, through: :cliente_imovel_retornos, class_name: 'ClienteRetorno'
end