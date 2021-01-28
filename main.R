library(here)
library(dplyr)
library(kableExtra)


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
data <- 
    data %>% 
        slice(3:n()) %>%
        mutate(
            estado = iconv(estado, from = "LATIN1", to = "UTF-8")
        )

states <- data %>% pull(estado)

# Reestructurar los datos con tidyr
long_data <- 
    data %>% 
        tidyr::pivot_longer(
            !estado, 
            names_to = "year", 
            values_to = "cantidad"
        )

# Uso de kable extra para visualización
by_states <- 
    with(long_data, 
        split(cantidad, estado)
    )

# "Layout" de la tabla
inline_plot <- 
    data.frame(
        estados = states, 
        boxplot = "",
        line = ""
    )

inline_plot %>%
    kbl() %>%
    # kable_material(c("striped", "hover")) %>%
    kable_paper(full_width = FALSE) %>%
    column_spec(
        column = 2, 
        image = spec_boxplot(by_states, width = 300, file_type = "png"), 
    ) %>%
    column_spec(
        column = 3, 
        image = spec_plot(mpg_list, same_lim = TRUE, file_type = "png")
    )