json.logradouros do
  json.array! @logradouros do |logradouro|
    json.extract! logradouro, :id, :nome, :titulo_logradouro_id, :logradouro_tipo_id, :municipio_id, :ativo, :nome_popular, :atualizado_em

    json.municipio(logradouro.municipio, :id, :nome) if logradouro.municipio
    json.titulo_logradouro(logradouro.titulo_logradouro, :id, :descricao) if logradouro.titulo_logradouro
    json.tipo_logradouro(logradouro.tipo_logradouro, :id, :descricao) if logradouro.tipo_logradouro
  end
end

json.page do
  json.total @total
  json.current_page @logradouros.current_page
  json.total_pages @logradouros.total_pages
  json.first_page @logradouros.first_page?
  json.last_page @logradouros.last_page?
end if @total