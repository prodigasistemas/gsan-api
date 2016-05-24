# GSAN Cadastro

Parte servidor/api dos cadastros do GSAN, que é utilizado em conjunto com o gsan_online

## Ambiente de Desenvolvimento

### Instalar o gerenciador de versões Ruby (http://rvm.io)
    curl -sSL https://get.rvm.io | bash -s stable
    
### Usar a versão 2 do Ruby
    rvm install 2.3.0

### Fazer o clone do projeto
    git clone [URL DO REPOSITÓRIO]

### Acessar o projeto
    cd gsan_cadastro

### Instalar as dependências do projeto
    bundle install

### Executar o gsan_cadastro em localhost:3001
    rails server -p 3001

## Ambiente de Teste

### Gerar usuário e senha
    echo "DB_USER=usuario" >> .env
    echo "DB_PASSWORD=senha" >> .env

### Executar os testes com a geração do relatório de cobertura, que será gravado na pasta coverage
    rake spec:coverage
