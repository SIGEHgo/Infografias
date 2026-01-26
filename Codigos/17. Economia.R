### Pendiente


poblacion = "Inputs/Drive/17. Economia/Economicamente Activa.xlsx" |>  readxl::read_excel(sheet = 3)
poblacion = poblacion |> 
  dplyr::select(-Índice)


names(poblacion)[1:5] = poblacion[5,][1:5]
names(poblacion)[6:8] = paste0("Población económicamente activa ", poblacion[7,][6:8])
names(poblacion)[9:10] = poblacion[6,][9:10]

names(poblacion) = names(poblacion) |>  stringr::str_squish()

poblacion = poblacion |> 
  dplyr::filter(`Grupos quinquenales de edad` == "Total") |> 
  dplyr::filter(Municipio != "Total") |> 
  dplyr::rename(
    `Población económicamente No especificado`= `No especificado`
  )


poblacion = poblacion |> 
  dplyr::mutate(
    CVE_MUN = Municipio |>  substr(start = 1, stop = 3),
    CVE_MUN = paste0("13", CVE_MUN) |>  stringr::str_squish()
    ) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::select(-Municipio, -`Entidad federativa`)



poblacion = poblacion |> 
  dplyr::select(-`Grupos quinquenales de edad`, -`Población de 12 años y más`)

poblacion = poblacion |> 
  tidyr::pivot_wider(
    names_from = Sexo,
    values_from = `Población económicamente activa Total`:`Población económicamente No especificado`,
    names_sep = " "
  )

names(poblacion) = names(poblacion) |>  stringr::str_squish()


















trabajadores = "Inputs/Drive/17. Economia/Trabajadores Totales-Trabajadores del sector primario,etc.xlsx" |>  
  readxl::read_excel()


trabajadores = trabajadores |> 
  dplyr::select(-`INEGI. Censo de Población y Vivienda 2020. Tabulados del Cuestionario Ampliado`) 

trabajadores = trabajadores |> 
  dplyr::mutate(
    CVE_MUN = Municipio |>  substr(start = 1, stop = 3) |>  stringr::str_squish()
  ) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::select(-Municipio) |> 
  dplyr::mutate(CVE_MUN = paste0("13", CVE_MUN) |>  stringr::str_squish())


unidades = "Inputs/Drive/17. Economia/Unidades Economicas.xlsx" |>  readxl::read_excel()
unidades = unidades |> 
  dplyr::select(...1, ...2, ...3,...7, ...8, ...15, ...22) |> 
  dplyr::rename(
    `Entidad Federativa` = ...1,
    `Municipio` = ...2,
    `Sector` = ...3,
    `Unidades Económicas` = ...7,
    `Unidades Económicas Personal Ocupado`= ...8,
    `Unidades Económicas Remuneraciones` = ...15,
    `Unidades Económicas Producción bruta total (millones de pesos)` = ...22
  )


unidades = unidades |> 
  dplyr::filter(`Entidad Federativa` == "13 Hgo." & !is.na(Municipio) & is.na(Sector))

unidades = unidades |> 
  dplyr::select(-`Entidad Federativa`, -Sector) |> 
  dplyr::mutate(
    Municipio = Municipio |>  stringr::str_squish()
  )


remesas = "Inputs/Drive/17. Economia/Ingresos por remesas.xlsx" |>  readxl::read_excel()
remesas = remesas |> 
  dplyr::rename(Municipio = `Ingresos por remesas distribuido por municipio`)


marginacion = "Inputs/Drive/17. Economia/Marginación.xlsx" |>  readxl::read_excel()

marginacion = marginacion |> 
  dplyr::select(-`Clave de la entidad federativa`)

marginacion = marginacion |> 
  dplyr::rename(
    `Índice de marginación 2020` = `Índice de marginación, 2020`,
    `Grado de marginación 2020` = `Grado de marginación, 2020`
  )


migratoria = "Inputs/Drive/17. Economia/MIGRACION.xlsx" |>  readxl::read_excel()

migratoria = migratoria |> 
  dplyr::rename(
    `Indice de migracición 2020` = `Indice de migracición`,
    `Intensidad de migración 2020` = `Intensidad de migración`
  ) |> 
  dplyr::mutate(
    CVE_GEO = CVE_GEO |>  as.character() |>  stringr::str_squish()
  )



datos = poblacion

mun = "../../Importantes_documentos_usar/Municipios/municipiosjair.shp" |>  sf::read_sf()
mun = mun |>  sf::st_drop_geometry() |> 
  dplyr::select(CVEGEO, NOM_MUN) |> 
  dplyr::rename(
    Municipio = NOM_MUN
  )


datos = datos |> 
  dplyr::left_join(y = mun, by = c("CVE_MUN" = "CVEGEO")) |> 
  dplyr::relocate(Municipio, .after = CVE_MUN)



datos = datos |> 
  dplyr::left_join(y = unidades, by = c("Municipio" = "Municipio")) |> 
  dplyr::left_join(y = trabajadores, by = c("CVE_MUN" = "CVE_MUN")) |> 
  dplyr::left_join(y = remesas, by = c("Municipio" = "Municipio")) |> 
  dplyr::left_join(y = marginacion |>  dplyr::select(-`Nombre del municipio`), by = c("CVE_MUN" = "Clave del municipio")) |> 
  dplyr::left_join(y = migratoria |>  dplyr::select(-NOM_MUN), by = c("CVE_MUN" = "CVE_GEO"))


datos |>  openxlsx::write.xlsx("Output/Drive/17. Economia.xlsx")
