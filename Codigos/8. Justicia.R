datos = "Inputs/Ejemplo/Banco de datos infografias _Eduardo_2024.xlsx" |>  readxl::read_excel()

names(datos) = names(datos) |> gsub(pattern = "\r\n", replacement = " ") |>  stringr::str_squish()

datos = datos |> 
  dplyr::filter(!is.na(Región)) |> 
  dplyr::select(Municipio, `Centros Penitenciarios`, `Centros de Reinserción`, `Centro Femenil de Reiserción Social`, `Población Penitenciaria Hombres`, `Población Penitenciaria Mujeres`) 


mun = "../../Importantes_documentos_usar/Municipios/municipiosjair.shp" |>  
  sf::read_sf() |>  
  sf::st_drop_geometry() |> 
  dplyr::select(CVE_MUN, NOM_MUN) |> 
  dplyr::mutate(CVE_MUN = paste0("13", CVE_MUN) |>  stringr::str_squish())


datos = datos |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio)


datos |>  openxlsx::write.xlsx("Output/Drive/8. Justicia.xlsx")
