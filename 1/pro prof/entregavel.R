# Trabalho realizado por 
# - Plancha, A.; CDC2; 105289 
# - Botas  , J.; CDC1; 104782

# Packages
library(tidyverse)
library(conflicted)
library(gridExtra)
library(ggplot2)
library(cowplot)
# Seed
set.seed(2023)

######################## Exercício 1 #######################################

dtriang <- function(x, a = 0, b = 1, c= 0.5) {
  # a -> min, b -> max, c -> mode
  data.table::fcase(
    x < a | x > b    , 0,
    x <= c           , 2 * (x - a) / ((b - a) * (c - a)),
    x > c            , 2 * (b - x) / ((b - a) * (b - c)),
    TRUE             , NA_real_
  )
}
extraDistr::dtriang(1:10,1,10,3)
dtriang(1:10,1,10,3)

rtriang <- function(n, a = 0, b = 1, c = 0.5, seed = 2023) {
  set.seed(seed)
  f <- \(x) dtriang(x, a, b, c)
  # proposed function
  g <- \(x) dunif(x, a, b)
  # x (random variable) generator 
  X <- \() runif(1, a, b)
  # c: max of f, so that c >= f(x) / g(x) for all x
  C <- f(c)/g(c) ## o maximo da funcao triangular e no dtriang(c)
  # monte carlo (u(0, 1) <= f(x) / (c*g(x)) <=> u(0, c*g(x)) <= f(x))
  u <- \(x) runif(n=1, min=0, max=1)
  
  ret <- c()
  while(length(ret) < n) {
    x <- X()
    if (u(x) <= f(x) / (C*g(x)))
      ret <- c(ret, x)
  }
  ret
}

# grafico 1,2
aceitacao_rejeicao_points <- function(n, a, b, c, seed = 2023) {
  set.seed(seed)
  f <- \(x) dtriang(x, a, b, c)
  # proposed function
  g <- \(x) dunif(x, a, b)
  # x (random variable) generator 
  X <- \() runif(1, a, b)
  # c: max of f, so that c >= f(x) / g(x) for all x
  C <- (f(c)/g(c)) ## o maximo da funcao triangular e no dtriang(c)
  # monte carlo (u(0, 1) <= f(x) / (c*g(x)) <=> u(0, c*g(x)) <= f(x))
  U <- \() runif(n=1, min=0, max=1)
  points <- tibble(x = numeric(0), y = numeric(0), accepted = factor(0))
  for(i in 1:n) {
    x <- X()
    u <- U()
    if(u <= f(x) / (C*g(x))) {
      points <- points %>% add_row(x = x, y = u, accepted = "Aceitado")
    } else {
      points <- points %>% add_row(x = x, y = u, accepted = "Rejeitado")
    }
  }
  return(points)
}

# a = 0, b = 100 e c = 50
set.seed(2023)
generated <- rtriang(10000, 0, 100, 50)
gg1 <- ggplot(tibble(x = generated), aes(x)) + 
  geom_histogram(aes(y = after_stat(density)), bins = 20, colour = "black", fill = "white") +
  geom_density(color = "#F73859", kernel = "gaussian", linewidth = 1, fill = "#F73859", alpha = 0.25) + 
  stat_function(fun = dtriang, args = list(a = 0, b = 100, c = 50), color = "#404B69", linewidth = 1) +
  labs(title = "a = 0, b = 100, c = 50", x = "x", y = "Densidade")

# a = 0, b = 10 e c = 5 mesmo teste /10
set.seed(2023)
generated2 <- rtriang(10000, 0, 10 ,5)

# a = 0, b = 100 e c = 50 pontos gerados
set.seed(2023)
gg2 <- ggplot(aceitacao_rejeicao_points(10000, 0, 100, 50), aes(x, y)) +
  geom_point(aes(color = accepted), alpha = 0.5, size = 0.4) +
  labs(title = "10000 Pontos gerados (0, 100, 50)", x = "x", y = "u") +
  scale_color_manual(values = c("Aceitado" = "#F73859", "Rejeitado" = "#404B69")) +
  theme(legend.position = "none")

# a = 1, b = 2, c = 1.2
set.seed(2023)
generated3 <- rtriang(10000, 1, 2, 1.2)
gg3 <- ggplot(tibble(x = generated3), aes(x)) + 
  geom_histogram(aes(y = after_stat(density)), bins = 20, colour = "black", fill = "white") +
  geom_density(color = "#F73859", kernel = "gaussian", linewidth = 1, fill = "#F73859", alpha = 0.25) + 
  stat_function(fun = dtriang, args = list(a = 1, b = 2, c = 1.2), color = "#404B69", linewidth = 1) +
  labs(title = "a = 1, b = 2, c = 1.2", x = "x", y = "Densidade")

# a = 0, b = 20 e c = 20
set.seed(2023)
generated4 <- rtriang(10000, 0, 20, 20)
gg4 <- ggplot(tibble(x = generated4), aes(x)) + 
  geom_histogram(aes(y = after_stat(density)), bins = 20, colour = "black", fill = "white") +
  geom_density(color = "#F73859", kernel = "gaussian", linewidth = 1, fill = "#F73859", alpha = 0.25) + 
  stat_function(fun = dtriang, args = list(a = 0, b = 20, c = 20), color = "#404B69", linewidth = 1) +
  labs(title = "a = 0, b = 20, c = 20", x = "x", y = "Densidade")


grid.arrange(gg1, gg2, gg3 , gg4, nrow=2, ncol=2,top="Distribuição triangular gerada") %>% 
  ggsave(filename = "mygrid_plot.svg", device = "svg", width = 2400, height= 1800, units = "px")


mean_triang <- \(a, b, c) (a + b + c) / 3
median_triang <- \(a, b, c) (2*c + b - a) / 4
variance_triang <- \(a, b, c) (a^2 + b^2 + c^2 - a*b - a*c - b*c) / 18
tribble(
  ~desc, ~mean, ~median, ~variance,
  "Teórico (a = 0, b = 100, c = 50)", mean_triang(0, 100, 50), median_triang(0, 100, 50), variance_triang(0, 100, 50),
  "Observado (a = 0, b = 100, c = 50)", mean(generated), median(generated), var(generated),
  "Teórico (a = 0, b = 10, c = 5)", mean_triang(0, 10, 5), median_triang(0, 10, 5), variance_triang(0, 10, 5),
  "Observado (a = 0, b = 10, c = 5)", mean(generated2), median(generated2), var(generated2),
  "Teórico (a = 1, b = 2, c = 1.2)", mean_triang(1, 2, 1.2), median_triang(1, 2, 1.2), variance_triang(1, 2, 1.2),
  "Observado (a = 1, b = 2, c = 1.2)", mean(generated3), median(generated3), var(generated3),
  "Teórico (a = 0, b = 20, c = 20)", mean_triang(0, 20, 20), median_triang(0, 20, 20), variance_triang(0, 20, 20),
  "Observado (a = 0, b = 20, c = 20)", mean(generated4), median(generated4), var(generated4)
) -> stats
stats
stats %>% knitr::kable( digits = 3, caption = "Estatísticas teóricas e observadas" )



######################## Exercício 2 #######################################

# a)

gerar_amostras <- function(n_amostras, dimensao_de_cada_amostra, seed = 2023) {
  set.seed(seed)
  df <- 10 # mesmos graus de liberdade para todas as amostras
  matrix(rt(n = n_amostras * dimensao_de_cada_amostra, df = df), nrow = dimensao_de_cada_amostra)
}

amostras_i   <- gerar_amostras(100, 20)
amostras_ii  <- gerar_amostras(100, 100)
amostras_iii <- gerar_amostras(100, 1000)

# b)

estim.s1 <- function(x){
  Q1 <- quantile(x, 0.25)
  Q2 <- quantile(x, 0.5)
  Q3 <- quantile(x, 0.75)
  (Q3+Q1-2*Q2)/(Q3-Q1)
}

estim.s2 <- function(x){
  miu <- mean(x)
  nu <- median(x)
  (miu - nu)/mean(abs(x - nu))
}

amostras_i.s1   <- apply(amostras_i,   2, estim.s1)
amostras_i.s2   <- apply(amostras_i,   2, estim.s2)
amostras_ii.s1  <- apply(amostras_ii,  2, estim.s1)
amostras_ii.s2  <- apply(amostras_ii,  2, estim.s2)
amostras_iii.s1 <- apply(amostras_iii, 2, estim.s1)
amostras_iii.s2 <- apply(amostras_iii, 2, estim.s2)

set.seed(2023)
df <- tibble(
  estimado = c(amostras_i.s1, amostras_i.s2, amostras_ii.s1, amostras_ii.s2, amostras_iii.s1, amostras_iii.s2),
  estimador = c(rep("s1", length( amostras_i.s1)),
                rep("s2", length( amostras_i.s2)),
                rep("s1", length(amostras_ii.s1)),
                rep("s2", length(amostras_ii.s2)),
                rep("s1", length(amostras_iii.s1)),
                rep("s2", length(amostras_iii.s2))),
  n_amostras_x_dimensao = c(rep("100x20", length(amostras_i.s1)),
                            rep("100x20", length(amostras_i.s2)),
                            rep("100x100", length(amostras_ii.s1)),
                            rep("100x100", length(amostras_ii.s2)),
                            rep("100x1000", length(amostras_iii.s1)),
                            rep("100x1000", length(amostras_iii.s2)))
)

df$n_amostras_x_dimensao <- factor(df$n_amostras_x_dimensao, levels = c("100x20", "100x100", "100x1000"))

box_jitter_ex2 <- ggplot(df, aes(x = estimador, y = estimado)) +
  geom_boxplot(aes(fill = estimador), alpha=0.6) + 
  geom_jitter(color="black", size=0.5, alpha=0.9) +
  scale_fill_manual(values=c("#F73859", "#404B69")) +
  facet_wrap(~ n_amostras_x_dimensao) + 
  labs(
    title = "Boxplot dos estimadores s1 e s2",
  )

ggsave(filename = "box_jitter_ex2.svg",plot = box_jitter_ex2, device = "svg", width = 2400, height= 1800, units = "px")

# c)

mse <- function(predicted, actual) {
  # actual aqui e só um valor por ser t-student -> simétrica
  sum((predicted - actual)^2) / length(predicted)
}
# skewness of t student is 0 for df > 3

df_metrics <- data.frame(
  `n_amostras x dimensao` = c("100x20", "100x100", "100x1000"),
  `Erro padrão de s_1` = c(sd(amostras_i.s1) %>% round(3), sd(amostras_ii.s1) %>% round(3), sd(amostras_iii.s1) %>% round(3)),
  `Erro padrão de s_2` = c(sd(amostras_i.s2) %>% round(3), sd(amostras_ii.s2) %>% round(3), sd(amostras_iii.s2) %>% round(3)),
  `Erro quadrático médio de s_1` = c(mse(amostras_i.s1, 0) %>% round(3), mse(amostras_ii.s1, 0) %>% round(3), mse(amostras_iii.s1, 0) %>% round(3)),
  `Erro quadrático médio de s_2` = c(mse(amostras_i.s2, 0) %>% round(3), mse(amostras_ii.s2, 0) %>% round(3), mse(amostras_iii.s2, 0) %>% round(3))
)
df_metrics




