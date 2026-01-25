hospedaje = "Inputs/Drive/18. Turismo/Establecimientos de hospedaje.xlsx" |>  
  readxl::read_excel() |> 
  dplyr::select(
    dplyr::where(fn = ~ !all(is.na(.)))
  ) 

hospedaje = hospedaje |> 
  dplyr::select(-...4)

names(hospedaje) = hospedaje[4,]  |> gsub(pattern = "-", replacement = "") |> 
  gsub(pattern = "\r\n", replacement = "") |> 
  stringr::str_squish() |> 
  gsub(pattern = "casasamuebladascon", replacement = "casas amuebladas con") |> 
  gsub(pattern = "ycasas", replacement = "y casas") |> 
  gsub(pattern = "dehuéspedes", replacement = "de huéspedes") |> 
  gsub(pattern = "serviciode", replacement = "servicio de") |> 
  stringr::str_squish() 

hospedaje = hospedaje |> 
  dplyr::filter(!is.na(Total)) |> 
  dplyr::slice(-c(1,2)) |> 
  dplyr::mutate(
    Municipio = Municipio |>  stringr::str_squish()
  ) |> 
  dplyr::rename(
    `Total Hospedajes` = Total 
  )






bebidas = "Inputs/Drive/18. Turismo/Bebidas.xlsx" |>  
  readxl::read_excel() |> 
  dplyr::select(
    dplyr::where(fn = ~ !all(is.na(.)))
  ) 


bebidas = bebidas |> 
  dplyr::select(-c(...2,...4)) |> 
  dplyr::filter(!is.na(...5))

names(bebidas) = bebidas[1,] |> 
  gsub(pattern = "-\r\n", replacement = "") |> 
  gsub(pattern = "\r\n", replacement = " ") |> 
  gsub(pattern = "-", replacement = "") |>  
  stringr::str_squish()

bebidas = bebidas |> 
  dplyr::slice(-c(1,2)) |> 
  dplyr::select(
    dplyr::where(fn = ~ !all(is.na(.)))
  ) |> 
  dplyr::mutate(
    Municipio = Municipio |>  stringr::str_squish()
  ) |> 
  dplyr::rename(
    `Total establecimientos bebidas`= Total
  )



mun = "../../Importantes_documentos_usar/Municipios/municipiosjair.shp" |>  sf::read_sf()
datos = mun |>  sf::st_drop_geometry() |> 
  dplyr::select(CVEGEO, NOM_MUN) |> 
  dplyr::left_join(y = hospedaje, by = c("NOM_MUN" = "Municipio")) |> 
  dplyr::left_join(y = bebidas, by = c("NOM_MUN" = "Municipio")) |> 
  dplyr::rename(
    Municipio = NOM_MUN
  ) |> 
  dplyr::arrange(Municipio)


datos |>  openxlsx::write.xlsx("Output/Drive/18. Turismo.xlsx")


