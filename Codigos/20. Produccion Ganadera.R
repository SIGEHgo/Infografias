mun = "../../Importantes_documentos_usar/Municipios/municipiosjair.shp" |>  
  sf::read_sf() |>  
  sf::st_drop_geometry() |>  
  dplyr::select(CVE_MUN, NOM_MUN) |> 
  dplyr::rename(
    `Municipio` = NOM_MUN
  ) |> 
  dplyr::mutate(CVE_MUN = paste0("13", CVE_MUN) |> stringr::str_squish())



agricola = "Inputs/Drive/20. Produccion Ganadera/Produccion Agricola 2024.xlsx" |>  readxl::read_excel()

names(agricola) = agricola[3,]

agricola = agricola |> 
  dplyr::filter(!is.na(`Superficie Sembrada (has.)`)) |> 
  dplyr::slice(-1) |> 
  dplyr::select(-Municipio)

agricola = agricola |> 
  dplyr::left_join(y = mun, by = c("clave Municipio" = "CVE_MUN")) |> 
  dplyr::rename(CVE_MUN = `clave Municipio`) |> 
  dplyr::relocate(Municipio, .after = CVE_MUN)


ganadera = "Inputs/Drive/20. Produccion Ganadera/Produccion Ganadera 2024.xlsx" |>  readxl::read_excel()
names(ganadera) = ganadera[3,]

ganadera = ganadera |> 
  dplyr::filter(!is.na(`Producción en toneladas de ganado en  pie de tipo bovino`)) |> 
  dplyr::slice(-1) |> 
  dplyr::select(-Municipio)





cultivos = "Inputs/Drive/20. Produccion Ganadera/Produccion Agricola -Cultivos- 2024.xlsx" |>  readxl::read_excel()

names(cultivos) = cultivos[3,]

cultivos = cultivos |> 
  dplyr::filter(!is.na(Cultivo)) |> 
  dplyr::slice(-1) |> 
  dplyr::mutate(Cultivo = paste0(Cultivo, " (",`Unidad de Medida`, ")") |>  stringr::str_squish()) |> 
  dplyr::select(-`Unidad de Medida`)

cultivos = cultivos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = `Superficie sembrada`:`Valor de la Producción`,
      .fns = ~.x |>  as.numeric()
    )
  )

cultivos = cultivos |>
  dplyr::group_by(`Clave Municipio`,Municipio, Cultivo) |>
  dplyr::summarise(
    dplyr::across(
      .cols = `Superficie sembrada`:`Valor de la Producción`,
      .fns = ~ sum(.x, na.rm = TRUE)
    )
  ) |> 
  dplyr::ungroup()


cultivos = cultivos |> 
  tidyr::pivot_wider(
    names_from = Cultivo,
    values_from = `Superficie sembrada`:`Valor de la Producción`,
    names_sep = " ",
    names_glue = "{Cultivo} { .value }"
  )


cultivos = cultivos |> 
  dplyr::select(`Clave Municipio`, dplyr::all_of(orden))




datos = agricola |> 
  dplyr::left_join(y = ganadera, by = c("CVE_MUN" = "Clave Municipio")) |> 
  dplyr::left_join(y = cultivos, by = c("CVE_MUN" = "Clave Municipio")) 



datos |>  openxlsx::write.xlsx("Output/Drive/20. Produccion Ganadera.xlsx")


