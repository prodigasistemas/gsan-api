json.clientes do
  json.array! @clientes do |cliente|
    json.extract! cliente,    :id,
                              :orgao_emissor_rg_id,
                              :orgao_emissor_uf_id,
                              :cliente_responsavel_superior_id,
                              :ramo_atividade_id,
                              :profissao_id,
                              :pessoa_sexo_id,
                              :cliente_tipo_id,
                              :nome,
                              :nome_abreviado,
                              :cpf,
                              :rg,
                              :data_emissao_rg,
                              :nascimento,
                              :cnpj,
                              :email,
                              :ativo,
                              :atualizado_em,
                              :vencimento,
                              :acao_cobranca,
                              :nome_mae,
                              :cobranca_acrescimos,
                              :arquivo_texto,
                              :vencimento_mes_seguinte,
                              :gera_fatura_antecipada,
                              :nome_fantasia_conta,
                              :permite_negativacao,
                              :negativacao_periodo
  end
end

json.partial! "shared/page", total: @total, models: @clientes
