#import "template.typ": *
#import "functions.typ": ifrac
#include "cabecalho.typ"
#import "@preview/algo:0.3.3": algo, i, d, comment, code //https://github.com/typst/packages/tree/main/packages/preview/algo/0.3.3
// #counter(page).update(1)

#show: project
= 1)
A distribuição triangular é uma distribuição contínua de probabilidades com uma forma de triângulo. É definida por 3 propriedades: o vértice inferior esquerdo $a$, o vértice inferior direito $b$, e o vértice superior $c$. A sua função de distribuição de probabilidade (FDP) pode ser definida por @fdp.
$
  Delta(x | a, b, c) := cases(
    0                     &"se" x < a,
    (2(x-a))/((b-a)(c-a)) &"se" a <= x < c,
    2/(b-a)               &"se" x = c,
    (2(b-x))/((b-a)(b-c)) &"se" a <= x < b,
    0                     &"se" b < x,
  )
$ <fdp>

// #figure(
//   image("images/triang_dist.png", width: 50%),
//   caption: [Distribuição triangular #footnote[_Wikimedia Commons_. #link("https://w.wiki/7gM$")]]
// )

O método da aceitação-rejeição é um método de Monte Carlo com o objetivo gerar de números pseudo-aleatórios (NPAs) de uma distribuição não-uniforme. Consiste num processo iterativo que pretende aceitar ou rejeitar NPAs $bold(X)$ geradas a partir do domínio ${x: f(x) != 0}$ de uma distribuição objetivo $f(x)$ de acordo com a probabilidade $P [X = x]$. Para isto, o processo irá gerar NPAs de uma outra distribuição $g(x)$ (cuja geração não seja dispendiosa) e compará-la perante NPAs de uma distribuição uniforme entre 0 e 1 $u(0, 1)$. Se @condicao se observar então $x$ é aceite como um NPA gerado de $f(x)$. O processo continua até a dimensão da amostra pretendida é obtida (ou um máximo de iterações é obtido, dependendo da implementação do algoritmo).

$
  u(0,1) < f(x)/(C g(x)), C in {lambda: lambda g(x) >= f(x)}
$ <condicao>

Para o máximo da eficiência do algoritmo, o $C$ escolhido deve ser o mais perto possível do máximo de $f(x)/g(x)$, pois o algoritmo terá maior probabilidade de gerar um número aceitável. Da mesma forma, é preferível que a forma de $g(x)$ seja uma parecida à forma de $f(x)$, sendo que a área de rejeição será menor. A distribuição $g(x)$ mais comum de escolher é a distribuição uniforme, devido à sua simplicidade, e à facilidade do cálculo do máximo de $f(x)/ g(x)$(desde que seja fácil determinar o máximo de $f(x)$).

#algo(
  title: "Gerador Aceitação-Rejeição",
  parameters: ("f(x)","g(x)", "C", "u([a, b])", "D{f(x)}"),
  indent-guides: 1pt + gray,
  indent-size:12pt,
  row-gutter: 8pt,
)[
  *ciclo*#i\
    $u <- u([0,1])$\
    $x <- u(D{f(x)})$\
    *se* $u <= f(x)/(C g(x))$ *produza* $u$\
    *se não* continuar o ciclo
]

O nosso objetivo foi gerar $10000$ NPAs proveninetes de $Delta(x)$ usando o método da aceitação-rejeição. Decidimos usar como $g(x)$ a distribuição uniforme (com domínio de $[a, b]$), pois o máximo de $Delta(x)$ será o parâmetro $c$, levando a que $C = f(c)/g(c)$. Na @resultados1 encontram-se os resultados das várias gerações executadas. 

Para demonstrar a precisão dos resultados, decdimos usar vários parâmetros diferentes e comparar com estatísticas teóricas, elas sendo a média, mediana, variância, e forma da distribuição. Decidimos também mostrar uma simulação da geração e dos pontos aceites e rejeitados (canto superior direito da @resultados1).
#figure(caption: "Distribuições geradas", gap: 1pt, kind:image)[
  #grid(
    rows: (auto), 
    columns: (auto, auto),
    gutter: auto,
    block()[
      #set text(size: 7pt)
      ```
            
          Estatísticas teóricas e observadas
            
desc	                              mean	 median	variance
Teórico (a = 0, b = 100, c = 50)	  50.000 50.000	416.667
Observado (a = 0, b = 100, c = 50)	50.001 49.924	413.893
Teórico (a = 0, b = 10, c = 5)	    5.000	 5.000	4.167
Observado (a = 0, b = 10, c = 5)	  5.000	 4.992	4.139
Teórico (a = 1, b = 2, c = 1.2)   	1.400  0.850	0.047
Observado (a = 1, b = 2, c = 1.2)	  1.398	 1.363	0.047
Teórico (a = 1, b = 100, c = 70)	  57.000 59.750	429.500
Observado (a = 1, b = 100, c = 70)	56.927 59.451	430.311
      ```
    ],
    image("images/mygrid_plot.svg", width: 90%),
  )
] <resultados1>
#figure(
   image("images/box_jitter_ex2.svg", width: 60%),
   caption: [Distribuição triangular para diferentes $f(x | a,b,c)$]
 )
Podemos obervar que as formas estão bastante semelhantes ao teórico, e as estatísticas amostras analisadas são extremamente semelhantes às teóricas, provando assim a eficácia do gerador e a confiância que podemos ter nele.

= 2

2!!!!