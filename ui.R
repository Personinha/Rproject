

header <- dashboardHeader(title = "Projeto de Estatística")

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Analisando uma Empresa", tabName = "m", icon = icon("chart-line")),
        menuItem('Comparando Ações da Cannabis', tabName = 'comp', icon = icon('chart-bar'))
    )
)

body <- dashboardBody(
    tabItems(
        ##DAS INFORMACOES UNICAS
        tabItem(tabName = 'm',
                fluidRow(
                    box(title = 'Selecione sua opção', width=12,background = "olive", solidHeader = TRUE, status='success',
                        selectInput('stock', 'Empresa', stock_list, multiple=FALSE),
                        uiOutput("timedate"),
                        actionButton('go', 'Submeter')
                        )
                ),
                fluidRow(
                    box(title = "Informações sobre a Ação", width = 12, solidHeader = TRUE,
                        DTOutput('info')
                    )
                ),
                fluidRow(
                    box(title = "Grafico em Linha (Preco de Fechamento)", width = 12, solidHeader = TRUE,
                        plotOutput('sh')
                    )
                ),
                fluidRow(
                    box(title = "Histograma (Volume de Negociacoes)", width = 12, solidHeader = TRUE,
                        plotOutput('sh2')
                    )
                ),
                fluidRow(
                    box(title = "Boxplot (Abertura, Fechamento, Maxima e Minima)", width = 12, solidHeader = TRUE,
                        plotOutput('sh3')
                    )
                ),
                
        ),
        ##COMPARANDO ACOES DE DUAS EMPRESAS
        tabItem(tabName = 'comp',
                fluidRow(
                    box(title = 'Selecione suas opções', width=12, background = "olive", solidHeader = TRUE, status='success', 
                        selectInput('stock1', 'Primeira Opção', stock_list, multiple=FALSE),
                        selectInput('stock2', 'Segunda Opção', stock_list, multiple=FALSE),
                        uiOutput("timedate1"),
                        actionButton('go2', 'Submeter ')
                    )
                ),
                fluidRow(
                    box(title = "Informações sobre as Ações", width = 12, solidHeader = TRUE,
                        DTOutput('info1')
                    )
                ),
                fluidRow(
                    box(title = "Grafico em Linha (Comparacao do Preco de Fechamento)", width = 12, solidHeader = TRUE,
                        plotOutput('sh4')
                    )
                ),
                fluidRow(
                    box(title = "Grafico de Barras Medias (Comparacao do Volume de Negociações)", width = 12, solidHeader = TRUE,
                        plotOutput('sh5')
                    )
                ),
        )
        
    )
)

ui <- dashboardPage(
    skin = 'green',
    header, sidebar, body)
