# Librerías ====
library(tidyverse)
library(extrafont)
# library(data.table) # Es posible

# Lectura ====
censo_pob <- read_csv("data/raw/cpv2020.csv") %>%
  janitor::clean_names()

dict_censo <- readxl::read_excel("data/raw/Censo2020_CPV_CB_descriptor_bd_ejemplo.xlsx",
  sheet = "PERSONAS",
  skip = 5) %>% 
    janitor::clean_names()

# Limpieza ====
dict_censo %>% 
    filter(!is.na(descripcion), !is.na(pregunta_y_categoria)) %>% 
    select(variable = mnemonico, descripcion) %>% 
    mutate(variable = str_to_lower(variable)) %>% 
    fst::write_fst("data/interim/cat_variables.fst", compress = 100)


censo_pob %>% 
    summarise(across(everything(), ~ sum(is.na(.x)))) %>% 
    pivot_longer(everything(), 
                 names_to = "variable", 
                 values_to = "missing") %>% 
    left_join(cat_variables) %>% 
    mutate(descripcion = fct_reorder(descripcion, missing), 
           missing = missing / 1e6) %>% 
    fst::write_fst("data/interim/missing_values_frame.fst")





