#################
### Municipal ###
#################

mun = "Output/Infografia_Base_Municipal_2026_Enero.xlsx" |>  readxl::read_excel()

datos = mun |> 
  dplyr::select(CVE_MUN, Kickapoo:`Popoluca insuficientemente especificado`)


prueba = datos |> 
  tidyr::pivot_longer(
    cols = Kickapoo:`Popoluca insuficientemente especificado`,
    names_to = "Lengua",
    values_to = "Hablantes") |> 
  dplyr::filter(Hablantes > 0) |>
  dplyr::group_by(CVE_MUN) |>
  dplyr::slice_max(Hablantes, n = 5, with_ties = F) |>
  dplyr::ungroup()



prueba2 = prueba |> 
  dplyr::group_by(CVE_MUN) |> 
  dplyr::mutate(
    posicion = dplyr::row_number()
  ) |> 
  tidyr::pivot_wider(
    names_from = posicion,
    values_from = c(Lengua, Hablantes),
    names_prefix = "Indigena"
  ) |>  
  dplyr::ungroup()

names(prueba2) = names(prueba2) |> 
  gsub(pattern = "Lengua_Indigena", replacement = "Lengua Indigena más hablada ") |> 
  gsub(pattern = "Hablantes_Indigena", replacement = "Lengua Indigena más hablada conteo ")


top5 = prueba |> 
  dplyr::group_by(CVE_MUN) |> 
  dplyr::summarise(
    `Lenguas Indigenas Top 5` = paste(Lengua, collapse = ", "),
    `Lenguas Indigenas Top 5 Conteo` = sum(Hablantes, na.rm = T)
  ) |> 
  dplyr::ungroup()


top5 = top5 |> 
  dplyr::left_join(y = prueba2, by = c("CVE_MUN" = "CVE_MUN"))

mun = mun |> 
  dplyr::left_join(y = top5, by = c("CVE_MUN" = "CVE_MUN"))


mun |>  openxlsx::write.xlsx("Output/Infografia_Base_Municipal_2026_Enero.xlsx")

################
### Regional ###
################

regional = "Output/Infografia_Base_Regional_2026_Enero.xlsx" |>  readxl::read_excel()

datos = regional |> 
  dplyr::select(Región, Kickapoo:`Popoluca insuficientemente especificado`)


prueba = datos |> 
  tidyr::pivot_longer(
    cols = Kickapoo:`Popoluca insuficientemente especificado`,
    names_to = "Lengua",
    values_to = "Hablantes") |> 
  dplyr::filter(Hablantes > 0) |>
  dplyr::group_by(Región) |>
  dplyr::slice_max(Hablantes, n = 5, with_ties = F) |>
  dplyr::ungroup()



prueba2 = prueba |> 
  dplyr::group_by(Región) |> 
  dplyr::mutate(
    posicion = dplyr::row_number()
  ) |> 
  tidyr::pivot_wider(
    names_from = posicion,
    values_from = c(Lengua, Hablantes),
    names_prefix = "Indigena"
  ) |>  
  dplyr::ungroup()

names(prueba2) = names(prueba2) |> 
  gsub(pattern = "Lengua_Indigena", replacement = "Lengua Indigena más hablada ") |> 
  gsub(pattern = "Hablantes_Indigena", replacement = "Lengua Indigena más hablada conteo ")


top5 = prueba |> 
  dplyr::group_by(Región) |> 
  dplyr::summarise(
    `Lenguas Indigenas Top 5` = paste(Lengua, collapse = ", "),
    `Lenguas Indigenas Top 5 Conteo` = sum(Hablantes, na.rm = T)
  ) |> 
  dplyr::ungroup()


top5 = top5 |> 
  dplyr::left_join(y = prueba2, by = c("Región" = "Región"))

regional = regional |> 
  dplyr::left_join(y = top5, by = c("Región" = "Región"))


regional |>  openxlsx::write.xlsx("Output/Infografia_Base_Regional_2026_Enero.xlsx")

##########################
### Zona Metropolitana ###
##########################

metropolitana = "Output/Infografia_Base_Zona_Metropolitana_2026_Enero.xlsx" |>  readxl::read_excel()

datos = metropolitana |> 
  dplyr::select(`Zona Metropolitana`, Kickapoo:`Popoluca insuficientemente especificado`)


prueba = datos |> 
  tidyr::pivot_longer(
    cols = Kickapoo:`Popoluca insuficientemente especificado`,
    names_to = "Lengua",
    values_to = "Hablantes") |> 
  dplyr::filter(Hablantes > 0) |>
  dplyr::group_by(`Zona Metropolitana`) |>
  dplyr::slice_max(Hablantes, n = 5, with_ties = F) |>
  dplyr::ungroup()



prueba2 = prueba |> 
  dplyr::group_by(`Zona Metropolitana`) |> 
  dplyr::mutate(
    posicion = dplyr::row_number()
  ) |> 
  tidyr::pivot_wider(
    names_from = posicion,
    values_from = c(Lengua, Hablantes),
    names_prefix = "Indigena"
  ) |>  
  dplyr::ungroup()

names(prueba2) = names(prueba2) |> 
  gsub(pattern = "Lengua_Indigena", replacement = "Lengua Indigena más hablada ") |> 
  gsub(pattern = "Hablantes_Indigena", replacement = "Lengua Indigena más hablada conteo ")


top5 = prueba |> 
  dplyr::group_by(`Zona Metropolitana`) |> 
  dplyr::summarise(
    `Lenguas Indigenas Top 5` = paste(Lengua, collapse = ", "),
    `Lenguas Indigenas Top 5 Conteo` = sum(Hablantes, na.rm = T)
  ) |> 
  dplyr::ungroup()


top5 = top5 |> 
  dplyr::left_join(y = prueba2, by = c("Zona Metropolitana" = "Zona Metropolitana"))

metropolitana = metropolitana |> 
  dplyr::left_join(y = top5, by = c("Zona Metropolitana" = "Zona Metropolitana"))

metropolitana |>  openxlsx::write.xlsx("Output/Infografia_Base_Zona_Metropolitana_2026_Enero.xlsx")

###############
### Estatal ###
###############

estatal = "Output/Infografia_Base_Estatal_2026_Enero.xlsx" |>  readxl::read_excel()

datos = estatal |> 
  dplyr::select(Kickapoo:`Popoluca insuficientemente especificado`)


prueba = datos |> 
  tidyr::pivot_longer(
    cols = Kickapoo:`Popoluca insuficientemente especificado`,
    names_to = "Lengua",
    values_to = "Hablantes") |> 
  dplyr::filter(Hablantes > 0) |>
  dplyr::slice_max(Hablantes, n = 5, with_ties = F) 



prueba2 = prueba |> 
  dplyr::mutate(
    posicion = dplyr::row_number()
  ) |> 
  tidyr::pivot_wider(
    names_from = posicion,
    values_from = c(Lengua, Hablantes),
    names_prefix = "Indigena"
  ) 

names(prueba2) = names(prueba2) |> 
  gsub(pattern = "Lengua_Indigena", replacement = "Lengua Indigena más hablada ") |> 
  gsub(pattern = "Hablantes_Indigena", replacement = "Lengua Indigena más hablada conteo ")


top5 = prueba |> 
  dplyr::summarise(
    `Lenguas Indigenas Top 5` = paste(Lengua, collapse = ", "),
    `Lenguas Indigenas Top 5 Conteo` = sum(Hablantes, na.rm = T)
  ) 


top5 = top5 |> 
  dplyr::bind_cols(prueba2)

estatal = estatal |> 
  dplyr::bind_cols(top5)


estatal |>  openxlsx::write.xlsx("Output/Infografia_Base_Estatal_2026_Enero.xlsx")

