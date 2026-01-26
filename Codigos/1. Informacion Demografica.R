datos = "Inputs/Ejemplo/Banco de datos infografias _Eduardo_2024.xlsx" |>  readxl::read_excel()

datos = datos |> 
  dplyr::filter(!is.na(`Densidad de Población (hab/km2)`)) |> 
  dplyr::select(Municipio:`Población adulta mayor (60 y más años)%`) |> 
  dplyr::select(-Región, -`Zona Metropolitana`)


mun = "../../Importantes_documentos_usar/Municipios/municipiosjair.shp" |> 
  sf::read_sf() |>  
  sf::st_drop_geometry()|>
  dplyr::select(CVE_MUN, NOM_MUN) |> 
  dplyr::mutate(
    CVE_MUN = paste0("13", CVE_MUN) |> stringr::str_squish(),
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


datos = datos |> 
  dplyr::select(
    -c(`Población total%`, `Población Mujeres%`, `Población Hombres%`, 
    `Población infantil (0-14 años)%`, `Población juvenil (15-29 años)%`,
    `Población (18 años y más)%`, `Población adulta (30-59 años)%`, 
    `Población adulta mayor (60 y más años)%`,
    `Superficie (km2)`,
    `Densidad de Población (hab/km2)`)
  )





demografica = "Inputs/Drive/1. Informacion Demografica/PSM2020_tabla_indicadores_entidad.xlsx" |>  
  readxl::read_excel(sheet = 3)


names(demografica) = names(demografica) |> 
  gsub(pattern = "\r\n", replacement = " ") |> 
  stringr::str_squish()


demografica = demografica |> 
  dplyr::filter(`Entidad federativa` == "13 Hidalgo") |>  
  dplyr::slice(-1)

demografica = demografica |> 
  dplyr::mutate(
    CVE_MUN = paste0("13",Municipio |>  substr(start = 1, stop = 3) |>  stringr::str_squish()),
    Municipio = Municipio |>  substr(start = 4,  stop = nchar(Municipio)) |>  stringr::str_squish()
  ) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio)


demografica = demografica |> 
  dplyr::select(CVE_MUN, `Superficie (km2)`, `Densidad de población (hab./km2)`)

datos = datos |> 
  dplyr::left_join(y = demografica, by = c("CVE_MUN" = "CVE_MUN"))

datos = datos |> 
  dplyr::relocate(c(`Superficie (km2)`, `Densidad de población (hab./km2)`), .after = Municipio) |> 
  dplyr::rename(`Población Urbana%` = `Población Urbana`,
                `Población Rural%` = `Población Rural`)


datos |> openxlsx::write.xlsx("Output/Drive/1. Informacion Demografica.xlsx")
