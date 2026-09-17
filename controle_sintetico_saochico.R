# ============================================================
#  CONTROLE SINTÉTICO — São Francisco de Paula (RS)
#  Impacto da política de turismo transversal (2017) sobre a
#  receita corrente municipal.
#  Pool de doadores: todos os 497 municípios do RS.
# ============================================================

library(Synth)
library(dplyr)
getwd()
painel <- read.csv("painel_rs_controle_sintetico.csv",
                   stringsAsFactors = FALSE, encoding = "UTF-8")

# Garantir tipos corretos
painel$cod <- as.numeric(painel$cod)
painel$ano <- as.numeric(painel$ano)
painel$municipio <- as.character(painel$municipio)

stopifnot(length(unique(painel$cod)) == 497)

trat_id      <- 4318200          # São Francisco de Paula
ano_interv   <- 2017             # início da política
anos_pre     <- 2010:2016        # período pré-tratamento
anos_todos   <- 2010:2024        # período total do gráfico
controles    <- setdiff(unique(painel$cod), trat_id)

# (dataprep)
# Preditores: médias 2010–2016 de PIB per capita, população e participações setoriais. A receita defasada entra como "special.predictors" em anos-chave do pré-tratamento.
dataprep.out <- dataprep(
  foo = painel,
  predictors = c("pib_pc", "pop", "part_agro", "part_ind", "part_serv"),
  predictors.op = "mean",
  time.predictors.prior = anos_pre,
  special.predictors = list(
    list("receita", 2010, "mean"),
    list("receita", 2013, "mean"),
    list("receita", 2016, "mean")
  ),
  dependent = "receita",
  unit.variable = "cod",
  unit.names.variable = "municipio",
  time.variable = "ano",
  treatment.identifier = trat_id,
  controls.identifier = controles,
  time.optimize.ssr = anos_pre,
  time.plot = anos_todos
)

# Rodar o controle sintético
synth.out <- synth(dataprep.out)

# Tabelas de resultado
# Pesos dos preditores e balanço (real vs sintético no pré-2017)
synth.tables <- synth.tab(dataprep.res = dataprep.out,
                         synth.res = synth.out)
print(synth.tables$tab.pred)   # balanço dos preditores
print(synth.tables$tab.v)      # pesos das variáveis (V)

# Municípios que compõem a "São Chico sintética" (pesos W > 0)
pesos <- synth.tables$tab.w
pesos <- pesos[order(-pesos$w.weights), ]
print(head(pesos, 15))         # os 15 maiores doadores

# trajetória real vs. sintética
path.plot(synth.res = synth.out,
          dataprep.res = dataprep.out,
          Ylab = "Receita corrente (R$)",
          Xlab = "Ano",
          Legend = c("São Francisco de Paula",
                     "São Francisco de Paula sintética"),
          Legend.position = "topleft")
abline(v = ano_interv, lty = 2, col = "red")   # linha da intervenção (2017)

# gap (efeito estimado ano a ano)
gaps.plot(synth.res = synth.out,
          dataprep.res = dataprep.out,
          Ylab = "Gap na receita (real - sintético)",
          Xlab = "Ano",
          Main = "Efeito estimado da política de turismo")
abline(v = ano_interv, lty = 2, col = "red")

# Extrair o gap em número
gap <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
colnames(gap) <- "gap_receita"
print(round(gap, 0))   # diferença real - sintético por ano
