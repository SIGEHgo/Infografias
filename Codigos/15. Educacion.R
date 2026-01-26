educacion = "Inputs/Drive/15. Educacion/Educación.xlsx" |>  readxl::read_excel()

educacion = educacion |> 
  dplyr::filter(!is.na(...2)) |> 
  dplyr::mutate(
    ...2 = dplyr::if_else(condition = !is.na(...1), true = ...1, false = ...2)
  )

educacion$...2[which(educacion$...1 == educacion$...2)] = "Total"

educacion = educacion |> 
  tidyr::fill(...1, .direction = "down") |> 
  dplyr::mutate(
    ...1 = ...1 |>  as.numeric() |> sprintf(fmt = "%03d"),
    ...1 = paste0("13",...1) |> stringr::str_squish()
  )


educacion = educacion |> 
  tidyr::pivot_wider(
    names_from = ...2,
    values_from = Escuelas:Docentes,
    names_sep = " ",
    values_fill = 0
  )

educacion = educacion |> 
  dplyr::rename(
    CVE_MUN = ...1  
  )


educacion |>  openxlsx::write.xlsx("Output/Drive/15. Educacion.xlsx")

















#####################
educacion = "Output/Drive/15. Educacion.xlsx" |>  readxl::read_excel()

analfabeta = "Inputs/Drive/15. Educacion/analfabetismo.xlsx" |>  readxl::read_excel()

analfabeta = analfabeta |> 
  dplyr::mutate(...1 = paste0("13", ...1 |>  substr(start = 1, stop = 3)) |>  stringr::str_squish()) |> 
  dplyr::rename(CVE_MUN = ...1)


escolaridad = "Inputs/Drive/15. Educacion/grado_prom_escolaridad_equivalencia.xlsx" |>  readxl::read_excel()

escolaridad = escolaridad |> 
  dplyr::mutate(cve_mpal = paste0("13", cve_mpal |>  stringr::str_pad(width = 3, side = "left", pad = 0)) |>  stringr::str_squish()) |> 
  dplyr::rename(CVE_MUN = cve_mpal) |> 
  dplyr::select(-NOM_MUN) |> 
  dplyr::rename(
    `Grado promedio de escolaridad Equivalencia`= Equivalencia
  )


desayunos = "Inputs/Ejemplo/Banco de datos infografias _Eduardo_2024.xlsx" |>  readxl::read_excel()

desayunos = desayunos |> 
  dplyr::filter(!is.na(Región)) |> 
  dplyr::select(Municipio,`Desayunos Integrados`, Uniformes, Becas)

mun = "../../Importantes_documentos_usar/Municipios/municipiosjair.shp" |>  
  sf::read_sf() |> 
  sf::st_drop_geometry() |>  
  dplyr::select(CVEGEO, NOM_MUN)

desayunos = desayunos |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVEGEO, .before = Municipio)




educacion = educacion |> 
  dplyr::left_join(y = escolaridad, by = c("CVE_MUN" = "CVE_MUN")) |> 
  dplyr::left_join(y = analfabeta, by = c("CVE_MUN" = "CVE_MUN")) |> 
  dplyr::left_join(y = desayunos, by = c("CVE_MUN" = "CVEGEO")) |> 
  dplyr::relocate(Municipio, .after = CVE_MUN)


