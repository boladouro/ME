# Trabalho realizado por 
# - Plancha, A.; CDC2; 105289 
# - Botas  , J.; CDC1; 104782

# Packages
library(tidyverse)
library(conflicted)
library(gridExtra)
library(ggplot2)
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

# a = 0, b = 100 e c = 50
set.seed(2023)
gg1 <- ggplot(tibble(x = rtriang(10000, 0, 10, 5)), aes(x)) + 
  geom_histogram(aes(y = after_stat(density)), bins = 20, colour = "black", fill = "white") +
  geom_density(color = "#F73859", kernel = "gaussian", linewidth = 1, fill = "#F73859", alpha = 0.25) + 
  stat_function(fun = dtriang, args = list(a = 0, b = 10, c = 5), color = "#404B69", linewidth = 1) +
  labs(title = "a = 0, b = 10, c = 5", x = "x", y = "Densidade")
# a = 0, b = 10 e c = 5
set.seed(2023)
gg2 <- ggplot(tibble(x = rtriang(10000, 0, 20, 20)), aes(x)) + 
  geom_histogram(aes(y = after_stat(density)), bins = 20, colour = "black", fill = "white") +
  geom_density(color = "#F73859", kernel = "gaussian", linewidth = 1, fill = "#F73859", alpha = 0.25) + 
  stat_function(fun = dtriang, args = list(a = 0, b = 20, c = 20), color = "#404B69", linewidth = 1) +
  labs(title = "a = 0, b = 20, c = 20", x = "x", y = "Densidade")
# a = 1, b = 2, c = 1.2
set.seed(2023)
gg3 <- ggplot(tibble(x = rtriang(10000, 1, 2, 1.2)), aes(x)) + 
  geom_histogram(aes(y = after_stat(density)), bins = 20, colour = "black", fill = "white") +
  geom_density(color = "#F73859", kernel = "gaussian", linewidth = 1, fill = "#F73859", alpha = 0.25) + 
  stat_function(fun = dtriang, args = list(a = 1, b = 2, c = 1.2), color = "#404B69", linewidth = 1) +
  labs(title = "a = 1, b = 2, c = 1.2", x = "x", y = "Densidade")
# a = 1, b = 100, c = 70
set.seed(2023)
gg4 <- ggplot(tibble(x = rtriang(10000, 1, 100, 70)), aes(x)) + 
  geom_histogram(aes(y = after_stat(density)), bins = 20, colour = "black", fill = "white") +
  geom_density(color = "#F73859", kernel = "gaussian", linewidth = 1, fill = "#F73859", alpha = 0.25) + 
  stat_function(fun = dtriang, args = list(a = 1, b = 100, c = 70), color = "#404B69", linewidth = 1) +
  labs(title = "a = 1, b = 100, c = 70", x = "x", y = "Densidade")

grid.arrange(gg1, gg2, gg3 , gg4, nrow=2, ncol=2,top="Distribuição triangular gerada") %>% 
  ggsave(filename = "mygrid_plot.svg", device = "svg", width = 2400, height= 1800, units = "px")

######################## Exercício 2 #######################################

# a)

gerar_amostras <- function(n_amostras, dimensao_de_cada_amostra, seed = 2023) {
  set.seed(seed)
  df <- dimensao_de_cada_amostra
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




