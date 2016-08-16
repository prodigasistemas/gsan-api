module Recadastramento
  module Arquivo
    class Cliente < Recadastramento::Base
      attr_accessor :id, :nome, :tipo_pessoa, :cpf_cnpj, :rg, :uf, :tipo_sexo

      alias_attribute :matricula_usuario, :id
      alias_attribute :nome_usuario, :nome
    end
  end
end