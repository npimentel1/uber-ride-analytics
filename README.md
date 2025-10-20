# 🚖 Uber Ride Analytics — Data Analysis Project

![Uber Ride Analytics](https://marketing.dcassetcdn.com/blog/2018/September/Uber-Wordmark/DI_Uber-Wordmark_Banner_828x300.jpg)

## 📄 Visão Geral

Projeto de **análise de dados de corridas Uber**, com foco em entender o comportamento das viagens, impacto financeiro das corridas incompletas e padrões de sazonalidade.  
Os dados foram extraídos do Kaggle e processados em **SQL Server**, com apoio de **Python** e **Excel** para validação e visualização inicial.  
O resultado final foi consolidado em um **case de estudo em PDF**, simulando um *executive report* de negócio.

> ⚠️ *Este projeto tem fins exclusivamente educacionais e demonstrativos.*

---

## 📊 Dataset

- **Nome:** Uber Ride Analytics  
- **Fonte:** [Kaggle - Uber Ride Analytics Dashboard](https://www.kaggle.com/datasets/yashdevladdha/uber-ride-analytics-dashboard/data)  
- **Autor:** [Yash Devladdha](https://www.kaggle.com/yashdevladdha)  
- **Licença:** [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)  

**Observação sobre dados faltantes no dataset:**  
> Os valores ausentes seguem o padrão lógico de geração de dados: `Booking Value` é nulo quando há cancelamento, pois não há faturamento.  
> Nenhum tratamento de imputação foi realizado, pois a ausência é **semântica e esperada**.

---

## 🧠 Objetivos da Análise

- 💵 Medir a **receita total** das corridas concluídas em 2024.  
- 🚫 Avaliar o **impacto financeiro** das corridas **incompletas e canceladas**.  
- 📈 Investigar o comportamento do **ticket médio e da distância percorrida** ao longo do ano.  
- ⏰ Identificar **faixas horárias** com maior incidência de cancelamentos e incompletas.  
- 🚗 Comparar a performance por **tipo de veículo** (Auto, Sedan, Premier, etc).

---

## Link direto para o relatório final

[📄 Ver Relatório Final](https://github.com/npimentel1/uber-ride-analytics/blob/main/report/Nikollas_Pimentel__Analista_de_dados.pdf)

---

## ⚙️ Stack Tecnológica

| Tecnologia | Função Principal |
|-------------|------------------|
| **Python** | Automação de download e tratamento inicial dos dados |
| **SQL Server (T-SQL)** | Criação de tabelas, procedures e consultas analíticas |
| **Excel** | Análises rápidas e validação de resultados |
| **PowerPoint** | Construção do relatório executivo em PDF |

---

## 🧩 Estrutura do Projeto

```bash
Uber_Ride_Analytics/
│
├── src/
│   └── download.py             # Script para baixar e carregar o dataset
│
├── sql/
│   ├── create_table.sql        # Criação da tabela base
│   ├── create_procedure_bulk_insert.sql  # Procedure para carga em massa
│   ├── analise.sql             # Consultas usadas na análise e no PDF
│   └── exec.sql                # Execução das procedures e inserts
│
├── report/
│   └── Uber_Ride_Analytics.pdf # Case final em formato de relatório
│
├── requirements.txt
├── README.md
└── base_uber.csv