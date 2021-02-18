# Librerías ====
library(tidyverse)

# Lectura y limpieza ====
lista_estados <- list.files(path = "data/raw/entidades", pattern = "ITER")

frame_estatales <- purrr::map(lista_estados,
           ~ read_csv(glue::glue("data/raw/entidades/{.x}"), 
                      na = "*") %>% 
               janitor::clean_names() %>% 
               select(nom_ent, nom_mun, nom_loc, starts_with("p_"))) %>% 
    set_names(lista_estados) %>% 
    bind_rows(.id = "archivo") %>% 
    pivot_longer(starts_with("p_"), 
                 names_to = "grupo_edades", 
                 values_to = "personas", 
                 names_prefix = "p_")

# purrr::map_dfr(lista_estados,
#            ~ read_csv(glue::glue("data/raw/entidades/{.x}"), 
#                       na = "*") %>% 
#                janitor::clean_names() %>% 
#                select(nom_ent, nom_mun, nom_loc, starts_with("p_")))


# Escritura ====
frame_estatales %>% 
    fst::write_fst("data/interim/frame_estatales.fst")







