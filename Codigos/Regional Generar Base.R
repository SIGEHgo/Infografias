datos = "Output/Infografia_Base_Municipal_Sin_Operaciones_2026_Enero.xlsx" |>  readxl::read_excel()

datos = datos |> 
  dplyr::rename(
    `Trabajadores del sector Terciario(Servicios)%` = `Trabajadores del sector Terciario(Servicios)`
  )

columnas_iniciales = names(datos)


datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = c(`Superficie (km2)`:`Número de áreas protegidas`, 
                `Cantidad promedio diaria de residuos sólidos urbanos recolectados`:`Grado promedio de escolaridad`,
                `Población de 15 años y más`:`Índice de marginación 2020`,
                `Indice de migracición 2020`,
                `Total Hospedajes`:`Popoluca insuficientemente especificado`), 
      .fns = ~ .x |>  as.numeric()
    )  
  )


### Para sacar esos promedios en un futuro
datos = datos |> 
  dplyr::mutate(
    `Promedio de ocupantes por vivienda_total_provisional_viviendas_particulares` = (`Promedio de ocupantes por vivienda`*`Viviendas particulares habitadas`) |> round(digits = 0),
    `Promedio de cuartos por vivienda_total_provisional_viviendas_particulares` = (`Promedio de cuartos por vivienda`*`Viviendas particulares habitadas`) |> round(digits = 0),
  ) 


### Va respecto viviendas particulares habitadas

particulares_habitadas = c(
  "Porcentaje de viviendas con 2.5 ocupantes o más por cuarto",
  "Porcentaje de viviendas con piso de tierra",
  "Porcentaje de viviendas sin energía eléctrica",
  "Porcentaje de viviendas sin agua entubada",
  "Porcentaje de viviendas sin sanitario ni drenaje",
  "% Viviendas particulares con hacinamiento"
  )



### Buen ejemplo para renombrar

# datos = datos |>
#   dplyr::mutate(
#     dplyr::across(
#       .cols = dplyr::any_of(particulares_habitadas),
#       .fns = ~ (.x/100 * `Viviendas particulares habitadas`) |>  round(digits = 0),
#       .names = "{.col}_total"
#     )
#   ) |>
#   dplyr::rename_with(
#     .cols = dplyr::any_of(paste0(particulares_habitadas, "_total")),
#     .fn = ~ .x |>  gsub(pattern = "Porcentaje de viviendas", replacement = "Total de viviendas") |>
#       gsub(pattern = "_total", replacement = "") |> gsub(pattern = "%", replacement = "") |>  stringr::str_squish()
#     )


datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = dplyr::any_of(particulares_habitadas),
      .fns = ~ (.x/100 * `Viviendas particulares habitadas`) |>  round(digits = 0),
      .names = "{.col}_total_provisional_viviendas_particulares" 
    )
  ) 



#### Respecto a poblacion total
### Nota con los valores de CONEVAL de poblacion total, no son los mismos

poblacion_total = c(
  "Rezago educativo 2020%",                                          
  "Carencia por acceso a los servicios de salud 2020%",              
  "Carencia por acceso a la seguridad social 2020%",                 
  "Carencia por calidad y espacios de la vivienda 2020%",            
  "Carencia por acceso a los servicios básicos en la vivienda 2020%",
  "Carencia por acceso a la alimentación 2020%",                     
  "Pobreza 2020%",                                                   
  "Pobreza extrema 2020%",                                           
  "Pobreza moderada 2020%",                                          
  "Vulnerables por carencia social 2020%",                           
  "Vulnerables por ingreso 2020%"  
)


# Eliminamos las del error

datos = datos |> 
  dplyr::select(
    -dplyr::any_of(
      poblacion_total |>  
        gsub(pattern = "2020%",  replacement = "Personas 2020") |> 
        stringr::str_squish()
    )
  ) 


datos = datos |>
  dplyr::mutate(
    dplyr::across(
      .cols = dplyr::any_of(poblacion_total),
      .fns = ~ (.x/100 * `Población total`) |>  round(digits = 0),
      .names = "{.col}_total"
    )
  ) |> 
  dplyr::rename_with(
    .cols = paste0(poblacion_total, "_total"),
    .fn = ~ .x |>  gsub(pattern = "2020%_total", replacement = "Personas 2020") |> stringr::str_squish()
  )

# Queda pendiente añadir los porcentajes posterior de cuando realicemos el summarise



### Respecto a Numero de Trabajadores

trabajadores_sector = c(
  "Trabajadores del Sector Primario%",                               
  "Trabajadores en el Sector secundario%",                           
  "Trabajadores del sector Terciario(Comercio)%",                    
  "Trabajadores del sector Terciario(Servicios)%"
)



datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = dplyr::any_of(trabajadores_sector),
      .fns = ~ (.x/100 * `Numero de Trabajadores`) |>  round(digits = 0),
      .names = "{.col}_total_provisional_numero_trabajadores" 
    )
  ) 



### Generar base

provisional = names(datos)[grepl("total_provisional", names(datos))]

source("Codigos/Columnas Regional Metropolitana y Estatal.R")

names(datos)[which(!names(datos) %in% sumas)]



faltantes = names(datos)[which(! names(datos) %in% sumas)] |>  as.data.frame()

datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = dplyr::any_of(c(sumas, promedios)),
      .fns = ~.x |>  as.numeric()
    )
  )


prueba = datos |> 
  dplyr::group_by(Región) |> 
  dplyr::summarise(
    dplyr::across(
      .cols = dplyr::any_of(sumas),
      .fns = ~ sum(.x, na.rm = T)
    ),
    dplyr::across(
      .cols = dplyr::any_of(provisional),
      .fns = ~ sum(.x, na.rm = T)
    ),
    dplyr::across(
      .cols = dplyr::any_of(concatenar),
      .fns = ~ paste(.x, collapse = ", ")
    ),
    dplyr::across(
      .cols = dplyr::any_of(promedios),
      .fns = ~ mean(.x, na.rm = T)
    )
  )












############ Aqui vamos a calcular las que arriba nos faltaba


prueba = prueba |> 
  dplyr::mutate(
    `Promedio de ocupantes por vivienda` = `Promedio de ocupantes por vivienda_total_provisional_viviendas_particulares` / `Viviendas particulares habitadas`,
    `Promedio de cuartos por vivienda` = `Promedio de cuartos por vivienda_total_provisional_viviendas_particulares` / `Viviendas particulares habitadas`
  ) |> 
  dplyr::select(
    -c(`Promedio de ocupantes por vivienda_total_provisional_viviendas_particulares`, `Promedio de cuartos por vivienda_total_provisional_viviendas_particulares`)
    )


paste0(particulares_habitadas, "_total_provisional_viviendas_particulares")


prueba = prueba |> 
  dplyr::mutate(
    dplyr::across(
      .cols = paste0(particulares_habitadas, "_total_provisional_viviendas_particulares"),
      .fns = ~ (.x / `Viviendas particulares habitadas`)*100, 
      .names = "{.col}"
    ) 
  ) |> 
  dplyr::rename_with(
    .cols = paste0(particulares_habitadas, "_total_provisional_viviendas_particulares"),
    .fn = ~ .x |>  gsub(pattern = "_total_provisional_viviendas_particulares", replacement = "") |>  stringr::str_squish()
  )



### Porcentajes pendientes


prueba = prueba |> 
  dplyr::mutate(
    dplyr::across(
      .cols = dplyr::any_of(poblacion_total |>
                              gsub(pattern = "2020%",  replacement = "Personas 2020") |>
                              stringr::str_squish()),
      .fns = ~ (.x / `Población total`)*100,
      .names = "{.col}%"
    ) |> 
      dplyr::rename_with(
        .cols = dplyr::any_of(poblacion_total |>
                                gsub(pattern = "2020%",  replacement = "Personas 2020%") |>
                                stringr::str_squish()),
        .fn = ~ .x |>  gsub(pattern = "Personas 2020%", replacement = "2020%") |> stringr::str_squish()
      )
  )




prueba = prueba |> 
  dplyr::mutate(
    dplyr::across(
      .cols = dplyr::any_of(trabajadores_sector |>  paste0("_total_provisional_numero_trabajadores")),
      .fns = ~(.x/`Numero de Trabajadores`)*100,
      .names = "{.col}"
    )
  ) |> 
  dplyr::rename_with(
    .cols = dplyr::any_of(trabajadores_sector |>  paste0("_total_provisional_numero_trabajadores")),
    .fn = ~ .x |>  gsub(pattern = "_total_provisional_numero_trabajadores", replacement = "") |>  stringr::str_squish()
    )



columnas_iniciales[!columnas_iniciales %in% names(prueba)]


prueba = prueba |> 
  dplyr::mutate(
    `Densidad de población (hab./km2)` = (`Población total` / `Superficie (km2)`),
    `Grado promedio de escolaridad Equivalencia` = dplyr::case_when(
      `Grado promedio de escolaridad` |>  floor() ==  6 ~ "6to grado de Primaria",
      `Grado promedio de escolaridad` |>  floor() ==  7 ~ "1er año de Secundaria",
      `Grado promedio de escolaridad` |>  floor() ==  8 ~ "2do año de Secundaria",
      `Grado promedio de escolaridad` |>  floor() ==  9 ~ "3er año de Secundaria",
      `Grado promedio de escolaridad` |>  floor() == 10 ~ "1er año de Preparatoria",
      `Grado promedio de escolaridad` |>  floor() == 11 ~ "2do año de Preparatoria",
      T ~ `Grado promedio de escolaridad` |>  as.character()
    ),
    `Grado de marginación 2020` = dplyr::case_when(
      `Índice de marginación 2020` >= 48.69173 & `Índice de marginación 2020` < 48.76876 ~ "Muy alto",
      `Índice de marginación 2020` >= 48.76876 & `Índice de marginación 2020` < 52.67477 ~ "Alto",
      `Índice de marginación 2020` >= 52.67477 & `Índice de marginación 2020` < 54.59623 ~ "Medio",
      `Índice de marginación 2020` >= 54.59623 & `Índice de marginación 2020` < 56.64808 ~ "Bajo",
      `Índice de marginación 2020` >= 56.64808 & `Índice de marginación 2020` <= 59.92392 ~ "Muy bajo",
      T ~ "Otro"
    ),
    `Intensidad de migración 2020` = dplyr::case_when(
      `Indice de migracición 2020` >= 51.16634 & `Indice de migracición 2020` < 59.44876 ~ "Muy alto",
      `Indice de migracición 2020` >= 59.44876 & `Indice de migracición 2020` < 61.42459 ~ "Alto",
      `Indice de migracición 2020` >= 61.42459 & `Indice de migracición 2020` < 63.10283 ~ "Medio",
      `Indice de migracición 2020` >= 63.10283 & `Indice de migracición 2020` < 64.37895 ~ "Bajo",
      `Indice de migracición 2020` >= 64.37895 & `Indice de migracición 2020` <= 65.15841 ~ "Muy bajo",
      T ~ "Otro"
    )
  )

prueba = prueba |> 
  dplyr::mutate(
    `Nombres áreas protegida` = `Nombres áreas protegida` |>  
      gsub(pattern = "NA,", replacement = "") |>  
      gsub(pattern = "NA", replacement = "") |> 
      stringr::str_squish() |> 
      gsub(pattern = ",\\s*$", replacement = "") |> 
      stringr::str_squish()
  )


prueba = prueba |> 
  dplyr::select(
    dplyr::any_of(columnas_iniciales)
  ) 

prueba |>  openxlsx::write.xlsx("Output/Infografia_Base_Regional_Sin_Operaciones_2026_Enero.xlsx")


