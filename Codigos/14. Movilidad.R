accidentes = "Inputs/Drive/14. Movilidad/Accidentes.xlsx" |>  readxl::read_excel()

accidentes = accidentes |> 
  dplyr::select(`Accidentes de tránsito terrestre, muertos y heridos en zonas urbanas y suburbanas por municipio`, ...5) |> 
  dplyr::filter(!is.na(...5)) |> 
  dplyr::rename(
    Municipio = `Accidentes de tránsito terrestre, muertos y heridos en zonas urbanas y suburbanas por municipio`,
    `Accidentes de Tránsito Registrados` = ...5
    ) |> 
  dplyr::mutate(
    Municipio = Municipio |>  stringr::str_squish()
  ) |> 
  dplyr::slice(-c(1:3))






automoviles = "Inputs/Drive/14. Movilidad/Vehiculos.xlsx" |>  
  readxl::read_excel() |>  
  dplyr::select(
    dplyr::where(fn = ~ !all(is.na(.)))
  ) 

automoviles = automoviles[, c(1,5:ncol(automoviles))]

names(automoviles) = paste(
    automoviles[4,] |> as.vector() |>  
      zoo::na.locf(na.rm = T) |>  
      unlist() |>  
      as.character() |> 
      gsub(pattern = "\r\n", replacement = " ") |> 
      gsub(pattern = "a/", replacement = " ") |>  
      stringr::str_squish(),
    automoviles[5,] |> 
      gsub(pattern = "-\r\n", replacement = "") |> 
      gsub(pattern = "\r\n", replacement = " ") |> 
      gsub(pattern = "-", replacement = "") |>  
      stringr::str_squish()
  ) |>  
    gsub(pattern = "NA", replacement = " ") |> 
    stringr::str_squish()


automoviles = automoviles |> 
  dplyr::mutate(
    Municipio = Municipio |>  stringr::str_squish(),
    Año = dplyr::case_when(
      Municipio == "2021" ~ "2021",
      Municipio == "2022" ~ "2022",
      Municipio == "2023" ~ "2023",
    )
  ) |> 
  dplyr::relocate(Año, .before = Municipio) |> 
  tidyr::fill(Año, .direction = "down") |> 
  dplyr::filter(!is.na(Total)) |> 
  dplyr::slice(-1) |> 
  dplyr::filter(Municipio != "Estado") |> 
  dplyr::rename(`Total de Vehiculos de motor`= Total)


automoviles = automoviles |> 
  tidyr::pivot_wider(
    names_from = Año,
    values_from = `Total de Vehiculos de motor`:`Motocicletas Particular`,
    names_sep = " "
  )







datos = automoviles |> 
  dplyr::left_join(y = accidentes, by = c("Municipio" = "Municipio"))


datos |>  openxlsx::write.xlsx("Output/Drive/14. Movilidad.xlsx")
