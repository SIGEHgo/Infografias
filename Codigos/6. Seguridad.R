datos = "Inputs/Ejemplo/Banco de datos infografias _Eduardo_2024.xlsx" |>  readxl::read_excel()

datos = datos |> 
  dplyr::filter(!is.na(Región)) |> 
  dplyr::select(Municipio,`Seguridad Total`, `Seguridad Total - Hombres`, `Seguridad Total - Mujeres`) |> 
  dplyr::rename (
    `Seguridad Total Hombres` =`Seguridad Total - Hombres`,
    `Seguridad Total Mujeres` = `Seguridad Total - Mujeres`
    )


mun = "../../Importantes_documentos_usar/Municipios/municipiosjair.shp" |>  
  sf::read_sf() |>  
  sf::st_drop_geometry() |> 
  dplyr::select(CVE_MUN, NOM_MUN) |> 
  dplyr::mutate(CVE_MUN = paste0("13", CVE_MUN) |>  stringr::str_squish())


datos = datos |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio)


datos |>  openxlsx::write.xlsx("Output/Drive/6. Seguridad.xlsx")
