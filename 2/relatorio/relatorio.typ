// Falta o cabeçalho
#import "template.typ": *
#show: project

#v(20pt)
#align(center, text(17pt)[
  *Passeio Aleatório: Comentário Curto*
])
#grid(
  columns: (1fr, 1fr),
  align(center)[
    André Plancha \
    105289, CDC2 \
    #link("mailto:Andre_Plancha@iscte-iul.pt")
  ],
  align(center)[
    Dr. John Doe \
    Artos Institute \
    #link("mailto:doe@artos.edu")
  ]
)
#v(15pt)

O algoritmo de Passeio Aleatório (PA) é um método de MCCM de classe de algoritmos _Metropolis-Hastings_, onde o próximo valor na cadeia $X_t = X_(t-1) + epsilon_t$, tendo $e_t$ uma distribuição simétrica; e.g. $X_(t+1) tilde cal(U)(X_t - lambda, X_t + lambda)$ ou $X_(t+1) tilde cal(N)(X_t, sigma^2)$. #footnote[Robert, C. P., & Casella, G. (2010). Introducing Monte Carlo Methods with R. Em _Springer eBooks_. https://doi.org/10.1007/978-1-4419-1576-4]

O PA consiste no seguinte:

1. Escolher $x_0$ de $D(f(x)), f(x) prop P(x)$,
2. Escolher uma distribuição candidata $G$ com $D(g(x_t | x_(t-1))) = D(f(x))$. \
3. Gerar um $x^*_t tilde G$.
4. Gerar $u tilde cal(U)(0,1)$ (Monte Carlo).
5. Calcular $alpha = f(x^*_t)/f(x_(t-1)) g(x_(t-1)|x^*_t)/g(x^*_t|x_(t-1))$.\ // = (f(x^*_t)\/g(x^*_t|x_(t-1)))/(f(x_(t-1))\/g(x_(t-1)|x^*_t)) 
   Como a distribuição candidata é simétrica, $g(x_(t-1)|x^*_t)/g(x^*_t|x_(t-1)) = 1 => alpha = f(x^*_t)/f(x_(t-1))$.
6. Se $alpha > u$, então $x_(t) = x^*_t$ \
   Se não, $x_(t) = x_(t-1)$
7. $t$ é incrementado, e o algoritmo repete a partir de 3.


Como isto é uma CM, há uma convergência para a distribuição $f(x)$.  //TODO ver se e preciso tirar

Podemos observar que embora $G$ não terá influência em $alpha$, terá influência na velocidade de convergência e na autocorrelação dos pontos. Isto está refletido na Figura 1. Ela apresenta evolução de várias cadeias geradas com o PA com uma $chi^2_2$ como distribuição objetivo, usando uma $cal(N)(0, sigma^2)$ como distribuição candidata, sendo a principal diferença entre as cadeias o $sigma$ escolhido.

Nas cadeias _rw.1_ e _rw.2_, podemos obersvar que embora os pontos sejam quase todos aceites, elas não se aproximam a $chi^2_2$, principalmente em _rw.1_ que nem parece convergir. Isto é porque $sigma$ é um valor demasiado baixo, tornando todos os valores de $alpha$ demasiado altos. A cadeia _rw.4_ parece observar-se o contrário, onde embora a cadeia se aproxima ao alvo, demasiados pontos são rejeitados devido ao número elevado de baixos $alpha$, devido a $sigma = 16$. Finalmente, _rw.3_ parece um bom compromisso, levando a uma aproximação à distribuição alvo que raramente rejeita pontos.

