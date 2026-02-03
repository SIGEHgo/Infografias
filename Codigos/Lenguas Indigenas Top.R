datos = "Output/Infografia_Base_Municipal_2026_Enero.xlsx" |>  readxl::read_excel()

datos = datos |> 
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
  )

names(prueba2) = names(prueba2) |> 
  gsub(pattern = "Lengua_Indigena", replacement = "Lengua Indigena más hablada ") |> 
  gsub(pattern = "Hablantes_Indigena", replacement = "Lengua Indigena más hablada conteo ")


top5 = prueba |> 
  dplyr::group_by(CVE_MUN) |> 
  dplyr::summarise(
    `Lenguas Indigenas Top 5` = paste(Lengua, collapse = ", "),
    `Lenguas Indigenas Top 5 conteo` = sum(Hablantes, na.rm = T)
  )
  