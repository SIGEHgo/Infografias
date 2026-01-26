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
    `Densidad de Población (hab/km2)`,
    `Población Rural`,
    `Población Urbana`)
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



urbana = "Inputs/Drive/1. Informacion Demografica/Poblacion.xlsx" |>  readxl::read_excel(sheet = 2)

names(urbana) = paste(
  urbana[5,] |> as.vector() |>  
  zoo::na.locf(na.rm = T) |>  
  unlist() |>  
  as.character(), 
  urbana[6,]
) |> gsub(pattern = "NA", replacement = " ") |> 
  stringr::str_squish()


urbana = urbana |> 
  dplyr::filter(`Localidades/Población` == "Población") |> 
  dplyr::slice(-1)

urbana = urbana |> 
  dplyr::mutate(
    dplyr::across(
      .cols = `Tamaño de localidad 1-249 habitantes`:`Tamaño de localidad 1 000 000 y más habitantes`,
      .fns = ~.x |>  as.numeric()
    )
  )

urbana = urbana |> 
  dplyr::mutate(
    `Población Rural` = `Tamaño de localidad 1-249 habitantes` +
      `Tamaño de localidad 250-499 habitantes` + `Tamaño de localidad 500-999 habitantes` +
      `Tamaño de localidad 1 000-2 499 habitantes`,
    `Población Urbana` = `Tamaño de localidad 2 500-4 999 habitantes` +
      `Tamaño de localidad 5 000-9 999 habitantes` + `Tamaño de localidad 10 000-14 999 habitantes` +
      `Tamaño de localidad 15 000-29 999 habitantes` + `Tamaño de localidad 30 000-49 999 habitantes` +
      `Tamaño de localidad 50 000-99 999 habitantes` + `Tamaño de localidad 100 000-249 999 habitantes` +
      `Tamaño de localidad 250 000-499 999 habitantes` + `Tamaño de localidad 500 000-999 999 habitantes` + 
      `Tamaño de localidad 1 000 000 y más habitantes`
  )


urbana = urbana |> 
  dplyr::mutate(
    Municipio = paste0("13", Municipio |>  substr(start = 1, stop = 3)) |>  stringr::str_squish()
  ) |> 
  dplyr::select(Municipio, `Población Rural`, `Población Urbana`)






datos = datos |> 
  dplyr::left_join(y = demografica, by = c("CVE_MUN" = "CVE_MUN")) |> 
  dplyr::left_join(y = urbana, by = c("CVE_MUN" = "Municipio"))

datos = datos |> 
  dplyr::relocate(c(`Superficie (km2)`, `Densidad de población (hab./km2)`), .after = Municipio) 

datos = datos |> 
  dplyr::relocate(c(`Población Rural`, `Población Urbana`), .after = `Población total`)


datos |> openxlsx::write.xlsx("Output/Drive/1. Informacion Demografica.xlsx")
