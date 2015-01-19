class Logradouro < ActiveRecord::Base
  include IncrementableId
  include Filterable

  self.table_name  = 'cadastro.logradouro'
  self.primary_key = 'logr_id'

  alias_attribute "id",                   "logr_id"
  alias_attribute "nome",                 "logr_nmlogradouro"
  alias_attribute "titulo_logradouro_id", "lgtt_id"
  alias_attribute "logradouro_tipo_id",   "lgtp_id"
  alias_attribute "municipio_id",         "muni_id"
  alias_attribute "ativo",                "logr_icuso"
  alias_attribute "atualizado_em",        "logr_tmultimaalteracao"
  alias_attribute "nome_popular",         "logr_nmpopular"

  has_many :logradouro_ceps, foreign_key: "logr_id", inverse_of: :logradouro
  has_many :ceps, through: :logradouro_ceps
  has_many :logradouro_bairros, foreign_key: "logr_id", inverse_of: :logradouro
  has_many :bairros, through: :logradouro_bairros
  belongs_to :titulo_logradouro, foreign_key: "lgtt_id"
  belongs_to :tipo_logradouro, foreign_key: "lgtp_id"
  belongs_to :municipio, foreign_key: "muni_id"

  accepts_nested_attributes_for :logradouro_ceps, allow_destroy: true
  accepts_nested_attributes_for :logradouro_bairros, allow_destroy: true

  scope :join, -> {
    includes(:municipio, :titulo_logradouro, :tipo_logradouro).
    eager_load(:municipio, :titulo_logradouro, :tipo_logradouro).
    order(:nome)
  }
  scope :nome, -> (nome) { where("UPPER(logr_nmlogradouro) LIKE ?", "%#{nome.upcase}%") }
  scope :municipio_id, -> (id) { where municipio_id: id }
  scope :titulo_logradouro_id, -> (id) { where lgtt_id: id }
  scope :tipo_logradouro_id, -> (id) { where lgtp_id: id }

  validates_presence_of :nome, :municipio_id, :logradouro_tipo_id
end
