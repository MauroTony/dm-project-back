# Desafio Tecnico
Projeto que simula um sistema de solicitação de credito.

O sistema foi dividido em 3 partes, Api, Front em FLutter e Microsserviço para se comunicar com a Api

O projeto consta com mais funcionalidades que o desafio tecnico solicita com a intenção de demonstrar mais habilidades tecnicas.

Para o projeto foram utilizado:
- Principios de DDD
- Principios de SOLID
- Docker para conteinerização dos sistemas
- Flask para RestApi
- Mongodb para persistencia dos dados
- Rabbitmq para comunicação entre os microsserviços

O Projeto também consta com:
- Deploy na AWS
- Pipeline de Deploy na AWS
- Cobertura de Testes para API
- Documentação dos Endpoints
  
Features:
- Modulo de usuario
- Modulo de autenticação com JWT
- Modulo de Cartão de Credito
- Modulo de analise de Credito como Microsserviço
- Front-End em flutter

Structure:
- api -> Flask RestApi
- dm-flutter -> Front-end em Flutter
- score-calculation -> Microsserviço
  
## Summary 
- [Docker Installation](#docker-installation) 
- [Mind Map](#mind-map) 
- [Production Link](#production-link)
  
## Docker Installation 
Instruções para instalação e configuração do projeto usando o Docker.

1. Clone o repositorio:  git clone https://github.com/MauroTony/dm-project-back.git 
2. Navegue até o diretório do projeto:  cd dm-project-back
3. Execute o docker compose: docker compose up --build -d
4. O projeto já consta enviroments definida com valores padrões
 ## Mind Map 
O Mapa mental abaixo foi utilizado para projeção da ideia do projeto.

Sua representação visual que ajuda a entender a estrutura e o fluxo do projeto.

[Mapa Mental](https://github.com/MauroTony/dm-project-back/assets/57079165/deb3fc7a-86c8-4f7a-9ac9-beb1a445764e)

## Production Link 
- [Project  Link](http://35.171.26.111:8080)

## Documentação
A documentação da API pode ser encontra nesse [link](https://documenter.getpostman.com/view/14325061/2s946eAtR5)

Documento do desafio tecnico pode-se encontrar aqui: [link](https://communication-assets.gupy.io/production/companies/934/emails/1688733069740/communication-assets-e8bfbdd0-1cc1-11ee-a776-87da19c60919/desenvolvedor_snior_python.pdf)
