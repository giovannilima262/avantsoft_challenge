# Avantsoft Sales API

API para gerenciamento de clientes, brinquedos e vendas, com documentação integrada via Apipie e cobertura de testes automatizados com RSpec.

## Pré-requisitos

- Docker (última versão)
- Docker Compose

## Configuração do Ambiente

1. **Edite o arquivo `.env.dev` e renomeie para `.env`**:

   ```bash
   cp .env.dev .env
   ```

2. **Instale as dependências do projeto**:

   ```bash
   docker compose run web bundle install
   ```

3. **Crie e migre o banco de dados**:

   ```bash
   docker compose run web rake db:create
   docker compose run web rake db:migrate
   ```

4. **Suba o ambiente**:

   ```bash
   docker compose up
   ```

## Acesso à documentação da API

Após subir o ambiente, acesse:

[http://localhost:3000/apipie](http://localhost:3000/apipie)

## Executando os Testes

1. **Crie e migre o banco de dados de testes**:

   ```bash
   docker compose run web rails db:create RAILS_ENV=test
   docker compose run web rails db:migrate RAILS_ENV=test
   ```

2. **Execute os testes**:

   ```bash
   docker compose run web bundle exec rspec
   ```

## Usando a api

1. **Todos os endpoints da aplicação fazem uso de um JWT token que precisa ser passado no header**
```bash
{
    "Authorization": "Bearer {token}"
}
```

2. **Existe um exemplo de usuário que já é registrado durante a migration. Basta chamar o seguinte endpoint**
```bash
POST /auth/login
{
    "name": "admin",
    "password": "admin"
}
```

3. **Use o token de retorno no header dos endpoints listados no "/apipie"**