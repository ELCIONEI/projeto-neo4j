# projeto-neo4j
Análise de Segurança de Redes e Vetores de Ataque com Neo4j
# 🛡️ Análise de Segurança de Redes e Vetores de Ataque com Neo4j

Este repositório apresenta uma modelação orientada a grafos para análise de topologia de redes, superfície de ataque, identificação de vulnerabilidades críticas e deteção de caminhos potenciais de movimento lateral.

## 🎯 Contexto e Justificação do Uso de Grafos
Ambientes corporativos e de cloud possuem centenas de dependências: permissões de utilizadores, serviços expostos e fluxos de rede interligados. Em bases de dados relacionais (SQL), mapear múltiplos saltos para encontrar rotas de invasão exige comandos `JOIN` pesados e complexos. O Neo4j permite navegar intuitivamente por relações em saltos arbitrários (`*1..3`), tornando a auditoria de segurança instantânea.

## 🗺️ Modelo de Dados
O grafo é composto pelos seguintes nós (`:Host`, `:User`, `:Vulnerability`, `:Port`, `:Subnet`) e relações (`:LOCALIZADO_EM`, `:ABRE`, `:VULNERAVEL_A`, `:TEM_ACESSO`, `:COMUNICA_COM`).

![Schema do Grafo](img/schema_model.png)

## 🚀 Como Executar o Projeto
1. Instale o Neo4j Desktop ou utilize uma instância gratuita no Neo4j AuraDB.
2. Abra o Neo4j Browser.
3. Execute o ficheiro `scripts/01_constraints.cypher` para criar restrições e índices.
4. Execute o ficheiro `scripts/02_load_data.cypher` para carregar o conjunto de dados.
5. Execute as consultas analíticas contidas em `scripts/03_business_queries.cypher`.

## 🔍 Perguntas de Negócio Respondidas
* **Quais servidores possuem vulnerabilidades críticas ativas e em que sub-redes operam?**
* **Quais utilizadores representam maior risco por falta de autenticação multifator (MFA)?**
* **Existe algum caminho de movimento lateral que permita alcançar o servidor de base de dados a partir de um nó na DMZ?**

![Resultado da Consulta de Movimento Lateral](img/query_lateral_movement.png)

## 🛠️ Dificuldades Encontradas e Soluções (Troubleshooting)
* **Desafio:** Garantir consistência nas conexões bidirecionais de rede.
* **Solução:** Optou-se por padronizar a relação `[:COMUNICA_COM]` no sentido da inicialização do handshake de rede, permitindo consultas direcionais precisas e análise reversa quando necessário.
```
