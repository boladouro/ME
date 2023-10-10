#import "template.typ": *
#import "functions.typ": ifrac
#include "capa.typ"
#import "@preview/algo:0.3.3": algo, i, d, comment, code //https://github.com/typst/packages/tree/main/packages/preview/algo/0.3.3
#import "@preview/tablex:0.0.5": gridx, tablex, rowspanx, colspanx, vlinex, hlinex
// #counter(page).update(1)

#show: project
#counter(page).update(1)
= 1)
A distribuição triangular é uma distribuição de probabilidades contínua com uma forma de triângulo. É definida por 3 propriedades: o vértice inferior esquerdo $a$, o vértice inferior direito $b$, e o vértice superior $c$. A sua função de distribuição de probabilidade (FDP) pode ser definida por @fdp.
$
  Delta(x | a, b, c) := cases(
    (2(x-a))/((b-a)(c-a)) &"se" a <= x <= c,
    (2(b-x))/((b-a)(b-c)) &"se" c <= x <= b,
    0                     &"em qualquer outro caso"
  )
$ <fdp>

// #figure(
//   image("images/triang_dist.png", width: 50%),
//   caption: [Distribuição triangular #footnote[_Wikimedia Commons_. #link("https://w.wiki/7gM$")]]
// )

O método da aceitação-rejeição é um método de Monte Carlo com o objetivo de gerar de números pseudo-aleatórios (NPAs) de uma distribuição não-uniforme. Consiste num processo iterativo que pretende aceitar ou rejeitar NPAs $bold(X)$ geradas a partir do domínio ${x: f(x) != 0}$ de uma distribuição objetivo $f(x)$ de acordo com a probabilidade $P [X = x]$. Para isto, o processo irá gerar pontos da área de uma distribuição $C dot g(x)$ e verificar se esses também pertencem à área de $f(x)$. Ou seja, se @condicao se observar então $x$ é "aceite" como um NPA gerado da distribuição de $f(x)$.

// o processo irá gerar NPAs de uma outra distribuição $g(x)$ (cuja geração não seja dispendiosa) e compará-la perante NPAs de uma distribuição uniforme entre 0 e 1 $u(0, 1)$. 

$
  C dot g(x) dot u(0,1) < f(x), C in {lambda: lambda g(x) >= f(x)}
$ <condicao>

Para o máximo da eficiência do algoritmo, o $C$ escolhido deve ser o mais perto possível do máximo de $f(x)/g(x)$, pois o algoritmo terá maior probabilidade de gerar um número aceitável. Da mesma forma, é preferível que a forma de $g(x)$ seja uma parecida à forma de $f(x)$, sendo que a área de rejeição será menor. A distribuição $g(x)$ mais comum de escolher é a distribuição uniforme, devido à sua simplicidade, e à facilidade do cálculo do máximo de $f(x)/ g(x)$(desde que seja fácil determinar o máximo de $f(x)$).

#figure(caption: "Gerador Aceitação-Rejeição", kind:"Algoritmo", supplement: "Algoritmo",placement: none, algo(
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
])

O nosso objetivo foi gerar $10000$ NPAs proveninetes de $Delta(x)$ usando o método da aceitação-rejeição. Decidimos usar como $g(x)$ a distribuição uniforme (com domínio de $[a, b]$), pois o máximo de $Delta(x)$ será o parâmetro $c$, levando a que $C = f(c)/g(c)$. Na @resultados1 encontram-se os resultados das várias gerações executadas. 

Para demonstrar a precisão dos resultados, decidimos usar vários parâmetros diferentes e comparar com estatísticas teóricas, elas sendo a média, mediana, variância, e forma da distribuição. Decidimos também mostrar uma simulação da geração e dos pontos aceites e rejeitados (canto superior direito da @resultados1).


#figure(caption: "Distribuições geradas", gap: 1pt, kind:image)[
  #grid(
    rows: (auto), 
    columns: (auto, auto),
    gutter: auto,
    block()[
      #set text(size: 7pt)
      ```md
Estatísticas teóricas e observadas

|desc                               |   mean| median| variance|
|:----------------------------------|------:|------:|--------:|
|Teórico (a = 0, b = 100, c = 50)   | 50.000| 50.000|  416.667|
|Observado (a = 0, b = 100, c = 50) | 49.798| 49.897|  417.380|
|Teórico (a = 0, b = 10, c = 5)     |  5.000|  5.000|    4.167|
|Observado (a = 0, b = 10, c = 5)   |  4.980|  4.990|    4.174|
|Teórico (a = 1, b = 2, c = 1.2)    |  1.400|  0.850|    0.047|
|Observado (a = 1, b = 2, c = 1.2)  |  1.398|  1.364|    0.047|*
|Teórico (a = 0, b = 20, c = 20)    | 13.333| 15.000|   22.222|
|Observado (a = 0, b = 20, c = 20)  | 13.320| 14.148|   22.419|
      ```
    ],
    image("images/mygrid_plot.svg", width: 90%),
  )
] <resultados1>


Podemos obervar que as formas estão bastante semelhantes ao teórico, e as estatísticas amostras analisadas são extremamente semelhantes às teóricas, provando assim a eficácia do gerador e a confiância que podemos ter nele. Os resultados completos encontram-se em anexo.

= 2)

O nosso objetivo neste problema foi avaliar e comparar o comportamento de dois estimadores para a assimetria: um usando quantis para o cálculo ($s_1$), e outro sendo o Coeficiente de Groeneveld e Meeden ($s_2$). Para isso, usámos um gerador da distribuição _t-student_, para gerar 3 conjuntos de 100 amostras, cada conjunto com diferentes dimensões de amostras; e calculamos métricas de erros entre o valor teórico (para $nu > 3$, a assimetira da distribuição será $0$)#footnote[Nós escolhemos como propriedade da distribuição _t-student_ usar graus de liberdade $nu = 10$, para facilitar a comparação dos estimadores e para a distribuição não se aproximar tanto a uma normal.], e os valores estimados. As métricas usadas foram o erro-padrão (EP) (desvio padrão de uma estimativa) e o erro quadrático médio (EQM).

O processo pode-se encontrar em anexo e na @resultados2 encontra-se os resultados obtidos.

#figure(caption: "Resultados dos estimadores",gridx(
  rows: (auto),
  columns: (auto, auto),
  gutter: auto,
  align:horizon,
  
  gridx(
    columns: 5,
    rows: 5,
    header-rows: 2,
    align:(x, y) => {
      if (x == 0){return right}; //header
      if (y in (0, 1)) {return center};//row-names
      return right
    },
    /* --- header --- */
    [],colspanx(2)[EP $arrow.b$], colspanx(2)[EQM $arrow.b$],
    hline_header(start:1, end:3), hline_header(start:3, end:5),
    [],[$s_1$],[$s_2$],[$s_1$], [$s_2$],
    hline(start:1),
    /* -------------- */
    [$100 times 20$], vline(start:2), [0.287],[*0.202*],[0.082],[*0.040*],
    [$100 times 100$], [0.134],[*0.088*],[0.018],[*0.008*],
    [$100 times 1000$],[0.041],[*0.031*],[0.002],[*0.001*],
  ),
  image("images/box_jitter_ex2.svg", height: 230pt)
)) <resultados2>

Pudemos obervar que a dispersão das assimetrias estimadas, e consequentemente a distância inter-quartil é bastante inferior usando $s_2$ em vez de $s_1$. Pudemos notar também que os valores das métricas de erro são menores usando $s_2$. Para além disso, verificamos que quanto maior a dimensão das amostras, mais preciso fica a nossa mediana da assimetria teórica da distribuição. Com isto, podemos concluir que:

- Quanto maior a dimensão das amostras, maior a precisão e exatidão dos estimadores;
- O estimador $s_2$ tem maior precisão e exatidão na estimação da assimetria na distribuição _t-student_.#footnote[Pelo menos quando $nu = 10$.]