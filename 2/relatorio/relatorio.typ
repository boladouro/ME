// Falta times new roman e as outras mariquises
// Falta o cabeçalho

O algorítmo de Passeio Aleatório (PA) é um método de Monte Carlo baseado nas Cadeias de Markov (MCCM) da classe de algorítmos de _Metropolis-Hastings_ (MH), diferenciando-se em $x_t ~ cal(N)(x_(t-1), sigma^2)$, o que leva a uma simetria da distribuição de probabilidade (d.p.).

O algorítmo de _Metropolis-Hastings_ consiste no seguinte:

1. Escolher um $x_0$ aleatório do domínio da função de d.p. objetivo $f(x) prop P(x)$, e escolher uma d.p. candidata $G$ (com função de d.p. $g(x_t | x_(t-1))$). \
   O PA usará a distribuição normal $G = cal(N)(x_(t-1), sigma^2)$ como candidata _a priori_. Será preciso também escolher $sigma$, o que representará o desvio padráo da distribuição.
2. Gerar um $x^*_t$ candidato da d.p. candidata
3. Gerar $u$ a partir de $cal(U)(0,1)$ (Monte Carlo)
4. Calcular $alpha = (f(x^*_t)\/g(x^*_t|x_(t-1)))/(f(x_(t-1))\/g(x_(t-1)|x^*_t)) = f(x^*_t)/f(x_(t-1)) g(x_(t-1)|x^*_t)/g(x^*_t|x_(t-1))$ \ #v(0pt) // why does it work
   Como a distribuição normal é simétrica, $g(x_(t-1)|x^*_t)/g(x^*_t|x_(t-1)) = 1$, logo $alpha =f(x^*_t)/f(x_(t-1)) $
5. Comparar $u$ com $alpha$ \
   Se $alpha > u$ então $x^*_t$ é aceite como $x^*_t$, e o algoritmo repete a partir do ponto 2 com o novo $t <- t+1$ (ou acaba dependendo da quantidade da amostra que pretendemos) \
   Se não, então $x^*_t$ é rejeitado e o algorítmo volta para o ponto 2 sem alterar $t$
Como isto é uma cadeia de Markov, para uma amostra suficientemente grande, há uma convergência para a distribuição $f(x)$.

Os gráficos ilustrados apresentam a importância da escolha do desvio padrão $sigma$.

AGR É TEU

Os gráficos ilustrados apresentam a convergência para a distribuição Qui-Quadrado com 2 graus de liberdade, sendo a principal diferença o desvio padrão e, por conseguinte, a variância. 

No gráfico 1, o desvio padrão da distribuição proponente simétrica é 0.05, fazendo com que gere somente valores consecutivos altos, em que todos são aceites. 
No gráfico 2, à semelhança do 3, vemos que a função converge para o domínio da Qui-Quadrado, aceitando quase na sua totalidade os pontos gerados. Contudo, para o gráfico 2 a convergência é lenta e no gráfico 3 é bastante mais elevada, devido à variância ser maior (diferença dos passos seguintes ser maior).
No gráfico 4, em contradição com o gráfico 1, a convergência é efetuada muito rapidamente, contribuindo para que o algoritmo não aceite pontos gerados e fique preso no mesmo sítio na execução das iterações (ter retas horizontais nas iterações vendo que permaneceu no último estado).

Talvez o mais ideal seria optar pelo gráfico 3 ou por um valor de desvio padrão entre os dois últimos gráficos, de forma a melhorar a eficácia da convergência, mas não rejeitando os pontos tal como acontece no gráfico 4, para um desvio padrão de 16.