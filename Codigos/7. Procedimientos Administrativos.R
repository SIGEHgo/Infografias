datos = "Inputs/Ejemplo/Banco de datos infografias _Eduardo_2024.xlsx" |>  readxl::read_excel()

datos = datos |> 
  dplyr::filter(!is.na(Región)) |> 
  dplyr::select(Municipio, `Procedimientos Administrativos`, `Procedimientos Administrativos A disposición de la guardia nacional`, `Procedimientos Administrativos A disposición de la policia estatal`, `Procedimientos Administrativos A disposición de la policia municipal`) 


mun = "../../Importantes_documentos_usar/Municipios/municipiosjair.shp" |>  
  sf::read_sf() |>  
  sf::st_drop_geometry() |> 
  dplyr::select(CVE_MUN, NOM_MUN) |> 
  dplyr::mutate(CVE_MUN = paste0("13", CVE_MUN) |>  stringr::str_squish())


datos = datos |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio)


datos |>  openxlsx::write.xlsx("Output/Drive/7. Procedimientos Administrativos.xlsx")
