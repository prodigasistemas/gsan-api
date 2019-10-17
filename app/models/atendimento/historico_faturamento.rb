class Atendimento::HistoricoFaturamento < Imovel
  def historico_faturamento
    cadastro = {}

    cadastro[:contas] = get_historico_contas
    cadastro[:debitos] = get_historico_debitos

    cadastro
  end

  private 

  def get_historico_debitos
    dados = []
    
    self.debito_a_cobrar.map do |debito|
      d = {}

      d[:tipo] = descricao_de debito.debito_tipo
      d[:data_referencia] = debito.data_opcao_debito_conta_corrente
      d[:data_cobranca]   = debito.ano_mes_cobranca_debito
      d[:cobradas]        = debito.numero_prestacao_cobradas
      d[:total]           = debito.numero_prestacao_debito
      d[:bonus]           = debito.numero_parcela_bonus
      d[:valor]           = debito.valor_debito

      situacao = debito.debito_credito_situacao_atual
      d[:situacao]        = situacao.present? ? situacao.abreviada : situacao
      d[:situacao_dica]   = descricao_de debito.debito_credito_situacao_atual

      dados << d
    end

    self.debito_a_cobrar_historico.map do |debito|
      d = {}

      d[:tipo] = descricao_de debito.debito_tipo
      d[:data_referencia] = debito.data_opcao_debito_conta_corrente
      d[:data_cobranca]   = debito.ano_mes_cobranca_debito
      d[:cobradas]        = debito.numero_prestacao_cobradas
      d[:total]           = debito.numero_prestacao_debito
      d[:bonus]           = debito.numero_parcela_bonus
      d[:valor]           = debito.valor_debito

      situacao = debito.debito_credito_situacao_atual
      d[:situacao]        = situacao.present? ? situacao.abreviada : situacao
      d[:situacao_dica]   = descricao_de debito.debito_credito_situacao_atual

      dados << d
    end

    dados
  end

  def get_historico_contas
    dados = []

    self.contas.map do |conta|
      c = {}

      agua     = conta.valor_agua     ||= 0
      esgoto   = conta.valor_esgoto   ||= 0
      debitos  = conta.valor_debitos  ||= 0
      creditos = conta.valor_creditos ||= 0
      impostos = conta.valor_impostos ||= 0

      c[:mes_ano]    = conta.ano_mes_referencia 
      c[:vencimento] = conta.data_vencimento
      c[:agua]       = agua
      c[:esgoto]     = esgoto
      c[:debitos]    = debitos
      c[:creditos]   = creditos
      c[:impostos]   = impostos
      c[:total]      = (agua + esgoto + debitos) - (creditos + impostos)
      c[:situacao_dica] = descricao_de conta.debito_credito_situacao

      situacao = conta.debito_credito_situacao
      c[:situacao]   = situacao.present? ? situacao.abreviada : situacao

      dados << c
    end

    dados
  end
end