# Librerías ====
library(tidyverse)

# Lectura ====
viviendas <- read_csv("data/raw/cpv2020_cb_viviendas_ej.CSV") %>% 
    janitor::clean_names() 


# Exp inicial ====
viviendas %>% 
    summarise(across(totcuart:con_vjuegos, ~ n_distinct(.x))) %>% 
    pivot_longer(cols = everything()) %>% 
    ggplot() +
    aes(y = fct_reorder(name, value), x = value) +
    geom_col()
# Se observa que existen varias variables categóricas

# Limpieza =====
viviendas %>% 
    mutate(across(totcuart:con_vjuegos, ~ factor(.x))) %>% 
    fst::write_fst("data/interim/viviendas_clean.fst")



