a)    …

b)    O algoritmo do Passeio Aleatório tem os mesmos fundamentos do Metropolis-hastings tradicional, ou seja, a convergência para a distribuição estacionária de uma cadeia de Markov. Distingue-se pela distribuição proponente simétrica e pela modelação dos passos ser dada pelo passo anterior somado a um valor gerado pela distribuição simétrica.

c)    Os gráficos ilustrados apresentam a convergência para a distribuição Qui-Quadrado com 2 graus de liberdade, sendo a principal diferença o desvio padrão e, por conseguinte, a variância. 

No gráfico 1, o desvio padrão da distribuição proponente simétrica é 0.05, fazendo com que gere somente valores consecutivos altos, em que todos são aceites. 
No gráfico 2, à semelhança do 3, vemos que a função converge para o domínio da Qui-Quadrado, aceitando quase na sua totalidade os pontos gerados. Contudo, para o gráfico 2 a convergência é lenta e no gráfico 3 é bastante mais elevada, devido à variância ser maior (diferença dos passos seguintes ser maior).
No gráfico 4, em contradição com o gráfico 1, a convergência é efetuada muito rapidamente, contribuindo para que o algoritmo não aceite pontos gerados e fique preso no mesmo sítio na execução das iterações (ter retas horizontais nas iterações vendo que permaneceu no último estado).

Talvez o mais ideal seria optar pelo gráfico 3 ou por um valor de desvio padrão entre os dois últimos gráficos, de forma a melhorar a eficácia da convergência, mas não rejeitando os pontos tal como acontece no gráfico 4, para um desvio padrão de 16.