# Librerías ====
library(tidyverse)
library(extrafont)

# Lectura ====
censo_estados <- fst::read_fst("data/interim/frame_estatales.fst") %>% 
    tibble()

# Limpieza ====
censo_estados  %>% 
    count(grupo_edades) %>% 
    print(n = Inf)

censo_est_clean <- censo_estados %>% 
    filter(str_ends(grupo_edades, "f|m"), 
           !str_detect(grupo_edades, "mas")) %>% 
    separate(grupo_edades, c("grupo_edades", "sexo"), sep = "_")  %>% 
    filter(nom_loc == "Total de la Entidad") 

# Figures ====
censo_est_clean  %>% 
    select(nom_ent, grupo_edades, sexo, personas) %>% 
    group_by(nom_ent) %>% 
    filter(grupo_edades != "15a49") %>% 
    mutate(tot_pob_entidad = sum(personas), 
           porc_pob = personas / tot_pob_entidad,
           dummy_factor = parse_number(grupo_edades), 
           grupo_edades = fct_reorder(str_replace(grupo_edades, "a", " - "), dummy_factor), 
           porc_pob = if_else(sexo == "m", -porc_pob, porc_pob)) %>% 
    ggplot(aes(y = factor(grupo_edades), x = porc_pob, fill = sexo)) +
    geom_col() +
    # geom_text(aes(label = scales::percent(porc_pob)), 
    scale_fill_manual(values = c("#28AA9A", "#F59A28"), 
                      labels = c("F", "M")) +
    labs(y = NULL, x = NULL, 
         title = "Estructura de la población", 
         legend = "Sexo") +
    ggthemes::theme_clean() +
    theme(axis.line.y = element_blank(), 
          text = element_text(family = "Roboto Mono for Powerline"))




