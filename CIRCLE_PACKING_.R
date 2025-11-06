# Carrega les llibreries necesàries
install.packages(c("tidyverse", "data.tree", "circlepackeR"))
library(tidyverse)
library(data.tree)
library(circlepackeR)
# El dataset s'ha extret de https://www.kaggle.com/datasets/gregorut/videogamesales
# Llegir el dataset i agafar nomes 3 publicadors
vgsales <- read.csv("C:/Users/Natalia/Desktop/MASTER UOC/SEGUNDO PRIMER QUATRI/VISUALITZACIO/PAC2/data/vgsales.csv")
vgsales <- vgsales %>%
  filter(Publisher %in% c("Nintendo", "Microsoft Game Studios", "Take-Two Interactive"))

# Agrupar per Publisher y Genre i sumar les ventes per regió
sales_summary <- vgsales %>%
  group_by(Publisher, Genre) %>%
  summarise(
    Global_Sales = sum(Global_Sales, na.rm = TRUE),
    NA_Sales = sum(NA_Sales, na.rm = TRUE),
    EU_Sales = sum(EU_Sales, na.rm = TRUE),
    JP_Sales = sum(JP_Sales, na.rm = TRUE),
    Other_Sales = sum(Other_Sales, na.rm = TRUE)
  ) %>%
  ungroup()

# Reestructurar les columnes com a files
sales_long <- sales_summary %>%
  pivot_longer(
    cols = c(NA_Sales, EU_Sales, JP_Sales, Other_Sales),
    names_to = "Region",
    values_to = "Sales"
  )

# Crear jerarquía: World / Publisher / Genre / Region
sales_long$pathString <- paste("World", sales_long$Publisher, sales_long$Genre, sales_long$Region, sep = "/")

# Convertir a estructura jeràrquica
sales_tree <- as.Node(sales_long[, c("pathString", "Sales")])

# Mostrar el circle packing interactiu
circlepackeR(
  sales_tree,
  size = "Sales",
  width = "100%",
  height = "700px"
)
