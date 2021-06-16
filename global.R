library(quantmod)
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(DT)
library(tidyverse)
library(tidyquant)
library(lubridate)
library(readr)
library(plotly)

Aurora <- read_csv("dataset/ACB.csv")
Aphria <- read_csv("dataset/APHA.csv")
Canopy <- read_csv("dataset/CGC.csv")
Cronos <- read_csv("dataset/CRON.csv")
Curaleaf <- read_csv("dataset/CURLF.csv")
Green <- read_csv("dataset/GTBIF.csv")
GW <- read_csv("dataset/GWPH.csv")
Harvest <- read_csv("dataset/HRVSF.csv")
Trulieve <- read_csv("dataset/TCNNF.csv")
Tilray <- read_csv("dataset/TLRY.csv")

##MANIPULANDO OS DATASETS PARA JUNTA-LAS EM UMA SÓ
Aurora <- Aurora[]
Stock <- rep("Aurora", nrow(Aurora))
Aurora <- cbind(Aurora, Stock)

Aphria <- Aphria[]
Stock <- rep("Aphria", nrow(Aphria))
Aphria <- cbind(Aphria, Stock)

Canopy <- Canopy[]
Stock <- rep("Canopy", nrow(Canopy))
Canopy <- cbind(Canopy, Stock)

Cronos <- Cronos[]
Stock <- rep("Cronos", nrow(Cronos))
Cronos <- cbind(Cronos, Stock)

Curaleaf <- Curaleaf[]
Stock <- rep("Curaleaf", nrow(Curaleaf))
Curaleaf <- cbind(Curaleaf, Stock)

Green <- Green[]
Stock <- rep("Green", nrow(Green))
Green <- cbind(Green, Stock)

GW <- GW[]
Stock <- rep("GW", nrow(GW))
GW <- cbind(GW, Stock)

Harvest <- Harvest[]
Stock <- rep("Harvest", nrow(Harvest))
Harvest <- cbind(Harvest, Stock)

Trulieve <- Trulieve[]
Stock <- rep("Trulieve", nrow(Trulieve))
Trulieve <- cbind(Trulieve, Stock)

Tilray <- Tilray[]
Stock <- rep("Tilray", nrow(Tilray))
Tilray <- cbind(Tilray, Stock)

##UNINDO OS DATAFRAMES
geral <- union_all(Tilray, Trulieve)
geral <- union_all(geral, Harvest)
geral <- union_all(geral, GW)
geral <- union_all(geral, Green)
geral <- union_all(geral, Curaleaf)
geral <- union_all(geral, Canopy)
geral <- union_all(geral, Cronos)
geral <- union_all(geral, Aphria)
geral <- union_all(geral, Aurora)

##DEFININDO O TIPO PARA A COLUNA DATE
geral$Date <- strptime(geral$Date, format='%Y-%m-%d')
stock_list <- c('Aurora', 'Aphria', 'Canopy', 'Cronos', 'Curaleaf', 'Green', 'GW', 'Harvest', 'Trulieve', 'Tilray')