class Atendimento::PagamentosImovel < Imovel
  def pagamentos
    cadastro = {}    

    contas  = []
    contas_historico  = []
    guias   = []
    guias_historico   = []
    debitos = []
    debitos_historico = []

    Pagamento.de_contas(self.id).each do |p|
      if(p.tipo_documento_id == DocumentoTipo::TIPO[:debito_a_cobrar])
        debitos << preenche_debito(p)
      elsif(p.tipo_documento_id == DocumentoTipo::TIPO[:guia_pagamento])
        guias << preenche_guia(p)
      else
        if(p.conta_geral.present? and p.conta_geral.indicador_historico == ContaGeral::INDICADOR[:historico])
          contas_historico << preenche_conta(p)
        else
          contas << preenche_conta(p)
        end
      end
    end

    PagamentoHistorico.de_contas(self.id).each do |p|
      if(p.tipo_documento_id == DocumentoTipo::TIPO[:debito_a_cobrar])
        debitos_historico << preenche_debito(p)
      elsif(p.tipo_documento_id == DocumentoTipo::TIPO[:guia_pagamento])
        guias_historico << preenche_guia(p)
      else
        contas_historico << preenche_conta(p)
      end
    end

    cadastro[:contas]  = contas
    cadastro[:contas_historico]  = contas_historico
    cadastro[:guias]   = guias
    cadastro[:guias_historico]   = guias_historico
    cadastro[:debitos] = debitos
    cadastro[:debitos_historico] = debitos_historico

    cadastro
  end

  private 

  def preenche_conta(pagamento)
    conta = {}

    conta[:mes_ano]     = pagamento.ano_mes_referencia 
    conta_geral         = pagamento.conta_geral

    if(conta_geral.present?)
      pagamento_conta     = conta_geral.conta 
      pagamento_conta     = conta_geral.conta_historico unless pagamento_conta.present?
      conta[:valor_conta] = pagamento_conta.valor_total if pagamento_conta.present?
    else      
      conta[:valor_conta] = nil
    end

    complemento(conta, pagamento)
  end

  def preenche_guia(pagamento)
    guia = {}

    guia[:cliente] = pagamento.cliente.nome if pagamento.cliente.present?
    guia[:tipo_debito] = descricao_de pagamento.debito_tipo

    guia_pagamento_geral = pagamento.guia_pagamento_geral
    
    if(guia_pagamento_geral)
      if(guia_pagamento_geral.has_attribute?(:valor_debito))
        guia[:valor_guia] = guia_pagamento_geral.valor_debito
      else
        guia[:valor_guia] = guia_pagamento_geral.guia_pagamento_historico.valor_debito if guia_pagamento_geral.guia_pagamento_historico.present?
      end
    end
    
    complemento(guia, pagamento)
  end

  def preenche_debito(pagamento)
    debito = {}

    debito[:tipo_debito] = descricao_de pagamento.debito_tipo

    debito_geral = pagamento.debito_a_cobrar_geral
    debito_geral = debito_geral.debito_a_cobrar || debito_geral.debito_a_cobrar_historico if debito_geral.present?

    debito[:valor_cobrado] = debito_geral.valor_debito if debito_geral.present?
    
    complemento(debito, pagamento)
  end

  def complemento(dados = {}, pagamento)  
    dados[:valor_pagamento]   = pagamento.valor_pagamento
    dados[:data_pagamento]    = pagamento.data_pagamento

    aviso_bancario = pagamento.aviso_bancario
    if(aviso_bancario.present?)
      dados[:arrecadador] = aviso_bancario.arrecadador.cliente.nome if aviso_bancario.arrecadador.cliente.present?
    else
      dados[:arrecadador] = agente_arrecadador(pagamento.cliente)
    end
 
    situacao_anterior = pagamento.situacao_pagamento_anterior
    dados[:situacao_anterior] = situacao_anterior.descricao_abreviada if situacao_anterior.present?
    dados[:situacao_anterior_dica] = descricao_de situacao_anterior

    situacao_atual = pagamento.situacao_pagamento_atual
    dados[:situacao_atual]    = situacao_atual.descricao_abreviada if situacao_atual.present?
    dados[:situacao_atual_dica] = descricao_de situacao_atual

    dados
  end

  def agente_arrecadador(pagamento_cliente)
    return unless pagamento_cliente.present?

    pagamento_cliente.nome
  end
end
