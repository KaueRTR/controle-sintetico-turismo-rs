# Avaliação de impacto da política de turismo de São Francisco de Paula (RS) sobre a receita municipal

**Controle sintético | R | 2010–2024 | Painel de 497 municípios**

Estimativa do efeito causal da adoção do turismo como eixo transversal de gestão municipal (2017) sobre a receita corrente de São Francisco de Paula, no Rio Grande do Sul.

---

## O problema

Em 2017, São Francisco de Paula passou a tratar o turismo como eixo transversal de gestão, articulando calendário oficial de eventos, investimento em infraestrutura turística e instrumentos de atração de investimento privado. O orçamento municipal cresceu fortemente nos anos seguintes.

Crescimento simultâneo, porém, não é efeito causal: municípios gaúchos de porte semelhante também expandiram receita no mesmo período. A pergunta deste trabalho é **quanto desse crescimento a política de fato explica**.

## Dados

Painel construído do zero: 497 municípios do Rio Grande do Sul × 15 anos = 7.455 observações. Três fontes públicas:

| Variável | Fonte |
| --- | --- |
| Receita corrente municipal | SICONFI/FINBRA (Secretaria do Tesouro Nacional) |
| PIB per capita e participação setorial no VAB | IBGE, SIDRA tabela 5938 |
| População | IPEADATA |

O tratamento dos dados foi parte relevante do trabalho: 81 lacunas na série de receita (concentradas em 2014), anos ausentes na série de população e dois códigos IBGE inexistentes vindos do IPEADATA. As lacunas foram resolvidas por interpolação linear e os códigos fantasma, removidos.

## Método

Controle sintético, estimado em R com o pacote `Synth`.

O método constrói uma unidade de comparação artificial — uma combinação ponderada de municípios não tratados — capaz de reproduzir a trajetória do município tratado no período anterior à intervenção. A diferença entre a trajetória observada e a da unidade sintética, depois de 2017, fornece a estimativa do efeito.

- **Unidade tratada:** São Francisco de Paula (código IBGE 4318200)
- **Intervenção:** 2017
- **Variável de resultado:** receita corrente municipal
- **Reservatório de doadores:** os 496 municípios restantes, sem exclusão manual de municípios turísticos — a ponderação fica por conta do algoritmo
- **Preditores:** PIB per capita, população e participação setorial (agropecuária, indústria, serviços)

## Resultados

O ajuste pré-2017 foi quase perfeito em todos os preditores, condição necessária para que a comparação pós-intervenção seja informativa.

A unidade sintética resultante é composta principalmente por:

| Município doador | Peso |
| --- | --- |
| Arroio Grande | 33,5% |
| Ciríaco | 26,6% |
| Vale do Sol | 18,5% |
| Santo Ângelo | 9,7% |
| Ronda Alta | 5,2% |
| Taquari | 2,9% |

O efeito estimado parte de **R$ 1,8 milhão em 2017** e chega a **R$ 38,4 milhões em 2024**. O salto relevante aparece a partir de 2019–2020, padrão compatível com defasagem de maturação de investimento: política de turismo não converte em arrecadação no ano da assinatura do decreto.

## Limitações e próximos passos

Os valores são nominais. Como todos os doadores são municípios gaúchos sujeitos à mesma inflação, o sintético absorve a tendência comum, mas deflacionar por IPCA é o refinamento natural.

O **teste de placebo** — reestimar o modelo tratando cada município do reservatório como se fosse o tratado, para verificar se o efeito de São Francisco de Paula se destaca da distribuição — não foi executado nesta versão. É o passo necessário antes de qualquer afirmação causal mais forte.

## Estrutura do repositório

```
├── README.md
├── dados/
│   └── painel_rs_controle_sintetico.csv    # painel final, 497 municípios × 15 anos
├── scripts/
│   └── controle_sintetico_saochico.R       # construção do modelo e estimação
└── resultados/
    ├── trajetoria_real_vs_sintetico.png
    └── gap_anual.png
```

## Como reproduzir

```r
install.packages(c("Synth", "dplyr"))
source("scripts/controle_sintetico_saochico.R")
```

A estimação com 496 doadores leva alguns minutos. O console do RStudio permanece ocupado durante o processo.

## Referências

- Abadie, A.; Gardeazabal, J. (2003). The Economic Costs of Conflict: A Case Study of the Basque Country. *American Economic Review*, 93(1), 113–132.
- Abadie, A.; Diamond, A.; Hainmueller, J. (2010). Synthetic Control Methods for Comparative Case Studies. *Journal of the American Statistical Association*, 105(490), 493–505.
- Abadie, A.; Diamond, A.; Hainmueller, J. (2015). Comparative Politics and the Synthetic Control Method. *American Journal of Political Science*, 59(2), 495–510.
- Abadie, A. (2021). Using Synthetic Controls: Feasibility, Data Requirements, and Methodological Aspects. *Journal of Economic Literature*, 59(2), 391–425.

## Autor

Kauê — graduando em Ciências Econômicas, PUCRS.
