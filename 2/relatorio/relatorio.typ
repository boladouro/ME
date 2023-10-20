// Falta o cabeçalho
#import "template.typ": *
#show: project
O algorítmo de Passeio Aleatório (PA) é um método de Monte Carlo baseado nas Cadeias de Markov (MCCM) da classe de algorítmos de _Metropolis-Hastings_, onde o próximo valor na cadeia $X_t = X_(t-1) + epsilon_t$, sendo $e_t$ uma pertubação aleatória com distribuição $G$ simétrica ($g(x) = g(-x)$, sendo $g$ a função de distribuição de probabilidade (f.d.p) de $G$). Exemplos destas são a distrbuição uniforme e a distribuição normal, levando a que $X_(t+1) tilde cal(U)(X_t - lambda, X_t + lambda)$ ou $X_(t+1) tilde cal(N)(X_t, sigma^2)$. #footnote[Robert, C. P., & Casella, G. (2010). Introducing Monte Carlo Methods with R. Em _Springer eBooks_. https://doi.org/10.1007/978-1-4419-1576-4]


O algorítmo de _Metropolis-Hastings_ consiste no seguinte:

1. Escolher um $x_0$ aleatório do domínio da função de d.p. objetivo $f(x) prop P(x)$, e escolher uma distribuição candidata $G$ (com f.d.p. $g(x_t | x_(t-1))$) de mesmo domínio. \
   O PA usará uma distribuição simétrica como candidata, de forma a garantir que $g(x_(t-1)|x^*_t) = g(x^*_t|x_(t-1))$. As propriedades da distribuição (como $sigma$ na distribuição normal) terão de ser escolhidas também, influenciando a cadeia.
2. Gerar um $x^*_t tilde G$.
3. Gerar $u$ a partir de $cal(U)(0,1)$ (Monte Carlo).
4. Calcular $alpha = f(x^*_t)/f(x_(t-1)) g(x_(t-1)|x^*_t)/g(x^*_t|x_(t-1))$.\ // = (f(x^*_t)\/g(x^*_t|x_(t-1)))/(f(x_(t-1))\/g(x_(t-1)|x^*_t)) 
   Como a distribuição candidata é simétrica, $g(x_(t-1)|x^*_t)/g(x^*_t|x_(t-1)) = 1 => alpha = f(x^*_t)/f(x_(t-1))$.
5. Comparar $u$ com $alpha$ \
   Se $alpha > u$ então $x^*_t$ é aceite como $x^*_t$, e o algoritmo repete a partir do ponto 2 com o novo $t <- t+1$ (ou acaba dependendo da quantidade da amostra que pretendemos) \
   Se não, então $x^*_t$ é rejeitado e o algorítmo volta para o ponto 2 sem alterar $t$

Como isto é uma cadeia de Markov, para uma amostra suficientemente grande, há uma convergência para a distribuição $f(x)$. Como isto é um PA, e a distribuição candidata é simétrica, $G$ não terá influência na condição de aceitação, mas sim na velocidade de convergência e na autocorrelação dos pontos. A calibração das propriedades de $G$ são importantes para chegar à aproximação de $f$, e a Figura 1 presente no *Problem Set 2* reflete isso.

A Figura 1 apresenta evolução de várias cadeias geradas com o PA com uma distribuição Qui-Quadrado $chi^2_2$ como distribuição objetivo, usando uma distribuição normal $cal(N)(0, sigma^2)$ como candidata, sendo a principal diferença entre as cadeias o $sigma$ escolhido. // evolução ou resultados? 


// TODO verificar isto dps do botas responder
Na cadeia _rw.1_, $sigma = 0.05$, fazendo com que gere somente valores consecutivos altos, em que todos são aceites. 

No gráfico 2, à semelhança do 3, vemos que a função converge para o domínio da Qui-Quadrado, aceitando quase na sua totalidade os pontos gerados. Contudo, para o gráfico 2 a convergência é lenta e no gráfico 3 é bastante mais elevada, devido à variância ser maior (diferença dos passos seguintes ser maior).
No gráfico 4, em contradição com o gráfico 1, a convergência é efetuada muito rapidamente, contribuindo para que o algoritmo não aceite pontos gerados e fique preso no mesmo sítio na execução das iterações (ter retas horizontais nas iterações vendo que permaneceu no último estado).

Talvez o mais ideal seria optar pelo gráfico 3 ou por um valor de desvio padrão entre os dois últimos gráficos, de forma a melhorar a eficácia da convergência, mas não rejeitando os pontos tal como acontece no gráfico 4, para um desvio padrão de 16.