# Librerías ====
library(tidyverse)
library(extrafont)
# library(data.table) # Es posible

# Lectura ====
missing_frame <- fst::read_fst("data/interim/missing_values_frame.fst")
cat_variables <- fst::read_fst("data/interim/cat_variables.fst")

# Gráfica ====
missing_frame %>% 
    ggplot() + 
    geom_col(aes(y = descripcion, x = missing), 
             fill = "#669F46", 
             color = 'black', 
             alpha = 0.8) +
    scale_x_continuous(labels = scales::comma) +
    labs(title = "La variable con mayor cantidad de nulos\n es la afiliación a seguridad social", 
         x = "Valores nulos\n(millones de observaciones)", 
         y = NULL, 
         caption = "Livecoding: @haro_ca_\n¡Gracias por verlo!") +
    ggthemes::theme_clean() +
    theme(text = element_text("Roboto Mono for Powerline")) +
    ggsave("figs/missing_values.png", height = 10, width = 8.5)
    
    
