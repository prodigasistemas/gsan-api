class ContratoMedicao < ActiveRecord::Base
  include IncrementableId
  include API::Filterable
  include API::Model

  self.table_name  = "desempenho.contrato_medicao"
  self.primary_key = "cmed_id"

  alias_attribute "id",                 "cmed_id"
  alias_attribute "numero",             "cmed_numero_contrato"
  alias_attribute "vigencia_inicial",   "cmed_vigencia_inicial"
  alias_attribute "vigencia_final",     "cmed_vigencia_final"
  alias_attribute "data_assinatura",    "cmed_data_assinatura"
  alias_attribute "empresa_id",         "empr_id"
  alias_attribute "atualizado_em",      "cmed_tmultimaalteracao"

  belongs_to :empresa, foreign_key: "empr_id"
  has_many :coeficientes, foreign_key: "cmed_id"
  has_many :abrangencias, foreign_key: "cmed_id"
  has_many :imoveis, through: :abrangencias

  validates :numero, :vigencia_inicial, :empresa_id, presence: true
  validates :numero, uniqueness: true

  def mes_ano_assinatura
    ("02" % data_assinatura.month.to_s) + "/" + data_assinatura.year.to_s
  end

  def ano_mes_vigencia_inicial
    vigencia_inicial.year.to_s + ("02" % vigencia_inicial.month.to_s)
  end

  def ano_mes_vigencia_final
    vigencia_final.year.to_s + ("02" % vigencia_final.month.to_s)
  end

  def redefinir
    historico_abrangencia_attrs = []
    data_remocao = Time.zone.now

    self.abrangencias.each do |abrangencia|
      historico_abrangencia_attrs << {
        cmab_tmcriacao: abrangencia.criado_em,
        cmab_tmremocao: data_remocao,
        cmed_id: self.id,
        imov_id: abrangencia.imovel_id
      }
    end

    HistoricoAbrangencia.inserir_varios(historico_abrangencia_attrs)
    Abrangencia.where(contrato_medicao_id: self.id).delete_all

    self.save
  end

  def referencia_assinatura
    "#{data_assinatura.year}#{data_assinatura.month.to_s.rjust(2, '0')}"
  end
end