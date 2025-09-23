![Uber Ride Analytics](https://marketing.dcassetcdn.com/blog/2018/September/Uber-Wordmark/DI_Uber-Wordmark_Banner_828x300.jpg)
# Uber Ride Analytics


##### *Projeto ainda em construção*

Análise de dados de corridas do Uber. Os dados utilizados foram obtidos do Kaggle e carregados em um banco de dados SQL Server, onde serão processados e preparados para análise no Excel.


## Tecnologias utilizadas

- Python
- SQL (SQL Server)
- Excel

## Objetivos

Realizar análise exploratória dos dados do dataset e responder as seguintes perguntas:
</br>
- Quais os principais GAPs na oferta x demanda?
- Análise da taxa de cancelamento (motorista e usuário)
- Avaliação de receita x método de pagamento x tipo de veículo
- Buscar correlação dos indicadores VTAT/CTAT
- Analisar o comportamento dos indicadores com clientes e motoristas com avaliações <= 3


## Dependências necessárias

É necessário que você tenha instalado o SQL Server no seu computador.

Em relação ao Python, instale todas as dependências com:

```
pip install -r requirements.txt
```

Principais bibliotecas utilizadas:

- kagglehub
- pandas
- os