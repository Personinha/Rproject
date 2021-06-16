

server <- function(input, output) {
    ################### INPUT ####################
    select_stock <- eventReactive(input$go, {
        
        stock_name <- input$stock
        twin <- input$true_date
        
        df_stock1 <- geral %>% 
            filter(Stock == stock_name)
            
        df_stock <- df_stock1 %>%
           filter(Date>as.Date(twin[1]) & Date<as.Date(twin[2]))

        
        return(df_stock)
    })
    ##multiplo
    select_stocks <- eventReactive(input$go2, {
      
      stock_name1 <- input$stock1
      stock_name2 <- input$stock2
      
      twin1 <- input$true_date1
      
      df_stock1 <- geral %>% 
        filter(Stock == stock_name1)
      
      df_stock2 <- geral %>% 
        filter(Stock == stock_name2)
      
      df_stocka <- df_stock1 %>%
        filter(Date>as.Date(twin1[1]) & Date<as.Date(twin1[2]))
      
      df_stockb <- df_stock2 %>%
        filter(Date>as.Date(twin1[1]) & Date<as.Date(twin1[2]))
      
      Mylist <- list("df1" =df_stocka, "df2" = df_stockb)
      
      return(Mylist)
      
    })
    ##unico
    output$timedate <- renderUI({
        stock_name <- input$stock
        
        df <- geral %>% 
            filter(Stock == stock_name)
        
        min_time <- min(df$Date)
        max_time <- max(df$Date)
        dateRangeInput("true_date", "Periodo de analise",
                       end = max_time,
                       start = min_time,
                       min  = min_time,
                       max  = max_time,
                       format = "dd/mm/yy",
                       separator = " - ",
                       language='pt-BR')
    })
    
    output$timedate1 <- renderUI({
      stock_name1 <- input$stock1
      stock_name2 <- input$stock2
      
      df1 <- geral %>% 
        filter(Stock == stock_name1)
      
      df2<- geral %>% 
        filter(Stock == stock_name2)

      
      min_time <- max(min(df1$Date), min(df2$Date))
      
      max_time <- min(max(df1$Date), max(df2$Date))
      
      dateRangeInput("true_date1", "Periodo de analise",
                     end = max_time,
                     start = min_time,
                     min  = min_time,
                     max  = max_time,
                     format = "dd/mm/yy",
                     separator = " - ",
                     language='pt-BR')
    })
    
    ################ OUTPUT #####################
    Info_DataTable <- eventReactive(input$go,{
        df <- select_stock()
        mean <- df %>% select(Close) %>% colMeans()
        Media <- mean[[1]]
        Mediana <- median(df$Close)
        
        getmode <- function(v) {
            uniqv <- unique(v)
            uniqv[which.max(tabulate(match(v, uniqv)))]
        }
        
        Moda <- getmode(df$Close)
        Desvio <- sd(df$Close)
        Maxima <- max(df$Close, na.rm = TRUE)
        Minima <- min(df$Close, na.rm = TRUE)
        Acao <- input$stock
        df_tb <-  data.frame(Acao, Media, Mediana, Moda, Desvio, Maxima, Minima)
        
        df_tb <- as.data.frame(t(df_tb))
        names(df_tb)[1] <- "Metricas"
      
        return(df_tb)
    })
    
    Info_DataTable1 <- eventReactive(input$go2,{
      df <- select_stocks()
      dataframe1 <- df$df1
      dataframe2 <- df$df2
      mean1 <- dataframe1 %>% select(Close) %>% colMeans()
      mean2 <- dataframe2 %>% select(Close) %>% colMeans()
      
      Media <- mean1[[1]]
      Mediana <- median(dataframe1$Close)
      
      getmode <- function(v) {
        uniqv <- unique(v)
        uniqv[which.max(tabulate(match(v, uniqv)))]
      }
      
      Moda <- getmode(dataframe1$Close)
      Desvio <- sd(dataframe1$Close)
      Maxima <- max(dataframe1$Close, na.rm = TRUE)
      Minima <- min(dataframe1$Close, na.rm = TRUE)
      Acao <- input$stock1
      
      Media2 <- mean2[[1]]
      Mediana2 <- median(dataframe2$Close)
      
      getmode <- function(v) {
        uniqv <- unique(v)
        uniqv[which.max(tabulate(match(v, uniqv)))]
      }
      
      Moda2 <- getmode(dataframe2$Close)
      Desvio2 <- sd(dataframe2$Close)
      Maxima2 <- max(dataframe2$Close, na.rm = TRUE)
      Minima2 <- min(dataframe2$Close, na.rm = TRUE)
      Acao2 <- input$stock2
      
      stock_1 <-  data.frame(Acao, Media, Mediana, Moda, Desvio, Maxima, Minima)
      stock_2  <-  data.frame(Acao2, Media2, Mediana2, Moda2, Desvio2, Maxima2, Minima2)
      df_tb <- data.frame(t(stock_1), t(stock_2))
      names(df_tb)[1] <- "Metricas 1"
      names(df_tb)[2] <- "Metricas 2"
      
      return(df_tb)
    })
    
    ##TABELA PAGINA 1
    output$info <- renderDT({
        Info_DataTable() %>%
            as.data.frame() %>% 
            DT::datatable(options=list(
                language=list(
                    url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json'
                )
            ))
    })
    
    ##TABELA PAGINA 2
    output$info1 <- renderDT({
      Info_DataTable1() %>%
        as.data.frame() %>% 
        DT::datatable(options=list(
          language=list(
            url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json'
          )
        ))
    })
    
    output$sh <- renderPlot({
        #GRAFICO DE LINHA
        df <- select_stock()
        
        aux <- df$Close %>% na.omit() %>% as.numeric()
        aux1 <- min(aux)
        aux2 <- max(aux)
        
        df$Date <- ymd(df$Date)
        a <- df %>% 
            ggplot(aes(Date, Close, group=1)) +
            geom_line() +
            geom_point() +
            geom_line(colour = "#000080") +
            ylab('Preço da Ação em $') +
            coord_cartesian(ylim = c(aux1, aux2)) +
            theme_bw() +
            scale_x_date(date_labels = "%Y-%m-%d")
        
        a
    })
    
    output$sh2 <- renderPlot({
        
        #HISTOGRAMA
        df <- select_stock()
        aux <- df$Volume %>% na.omit() %>% as.numeric()
        aux1 <- min(aux)
        aux2 <- max(aux)
        
        df$Date <- ymd(df$Date)
       a <-  ggplot(df, aes(Date, Volume, group=1)) +
            geom_histogram(stat='identity', aes(fill=Volume)) +
            labs(x="Data", y='Volume de Negociacoes') +
            theme_bw() +
            xlim(c(aux1,aux2)) +
            scale_x_date(date_labels = "%Y-%m-%d")
        a
        
    })
    output$sh3 <- renderPlot({
        
        #BOXPLOT
        df <- select_stock()
        
        aux <- df$Close %>% na.omit() %>% as.numeric()
        aux1 <- min(aux)
        aux2 <- max(aux)

        
        df$Date <- ymd(df$Date)
        a <- df %>% 
            ggplot(aes(x = Date, y = Close)) +
            geom_candlestick(aes(open = Open, high = High, low = Low, close = Close), color_up = "green", color_down = "red", 
                             fill_up  = "green", fill_down  = "red") +
            geom_ma(color = "darkgreen") +
          theme_void() +
            xlim(c(aux1, aux2)) +
            scale_x_date(date_labels = "%Y-%m-%d")
        a
    })
    
    output$sh4 <- renderPlot({
      
      #GRAFICO DE COMPARACAO LINHA
      df <- select_stocks()
      
      dataframe1 <- df$df1
      dataframe2 <- df$df2
      
      aux <- dataframe1$Close %>% na.omit() %>% as.numeric()
      aux1 <- min(aux)
      aux2 <- max(aux)
      
      dataframe1$Date <- ymd(dataframe1$Date)
      dataframe2$Date <- ymd(dataframe2$Date)
      
      a <-
        ggplot() +
        geom_line(data = dataframe1, aes(x = Date, y = Close), color = "deepskyblue") +
        geom_line(data = dataframe2, aes(x = Date, y = Close), color = "darkblue") +
        geom_point() +
        geom_line(colour = "#000080") +
        ylab('Preço da Ação') +
        coord_cartesian(ylim = c(aux1, aux2)) +
        theme_bw() +
        scale_x_date(date_labels = "%Y-%m-%d")
      
      a
      
    })
    
    output$sh5 <- renderPlot({
      
      #GRAFICO DE COMPARACAO BARRA
      df1 <- select_stocks()
      
      dataframe1 <- df1$df1
      dataframe2 <- df1$df2
      
      df <- union_all(dataframe1, dataframe2)
      
      aux <- df$Close %>% na.omit() %>% as.numeric()
      aux1 <- min(aux)
      aux2 <- max(aux)
      
      df$Date <- ymd(df$Date)

      
      a <- ggplot(df, aes(Date, Volume, group=1)) +
        geom_histogram(stat='identity', aes(fill=Stock)) +
        labs(x="Data", y='Volume de Negociacoes') +
        theme_light() +
        xlim(c(aux1,aux2)) +
        scale_x_date(date_labels = "%Y-%m-%d")
      a
    })
}
