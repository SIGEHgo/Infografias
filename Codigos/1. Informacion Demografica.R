datos = "Inputs/Banco de datos infografias _Eduardo.xlsx" |>  readxl::read_excel()

datos = datos |> 
  dplyr::filter(!is.na(`Densidad de Población (hab/km2)`)) |> 
  dplyr::select(Municipio:`Población adulta mayor (60 y más años)%`) |> 
  dplyr::select(-Región, -`Zona Metropolitana`)


mun = "../../Importantes_documentos_usar/Municipios/municipiosjair.shp" |> 
  sf::read_sf() |>  
  sf::st_drop_geometry()|>
  dplyr::select(CVE_MUN, NOM_MUN) |> 
  dplyr::mutate(
    CVE_MUN = paste0("13", CVE_MUN),
    NOM_MUN = NOM_MUN |> stringr::str_squish()
    ) 

datos = datos |> 
  dplyr::mutate(
    Municipio = Municipio |>  stringr::str_squish()
  ) |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio)




names(datos) = names(datos) |>  gsub(pattern = "\r\n", replacement = " ") |>  stringr::str_squish()

datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = `Superficie (km2)`:`Población adulta mayor (60 y más años)%`,
      .fns = ~.x |>  as.numeric()
    )
  )


datos |> openxlsx::write.xlsx("Output/1_Informacion_Demografica.xlsx")
