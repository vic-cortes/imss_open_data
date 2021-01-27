library(here)
library(dplyr)


data <- 
    readr::read_csv(
        here("data", "istabla43_2019.csv"), 
        col_names = FALSE
    )

column_names <- data %>% slice_head() %>% as.character()
column_names[1] <- "estado"

# Renombrar columnas
names(data) <- column_names

# Eliminar primaras dos filas
data <- data %>% slice(3:n())

# Reestructurar los datos con tidyr
data %>% 
    tidyr::pivot_longer(!estado, names_to = "year", values_to = "cantidad")