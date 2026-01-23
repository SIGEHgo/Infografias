pobreza = "Inputs/Drive/5. Pobreza/Pobreza por Municipio 2020.xlsx" |>  readxl::read_excel()


names(pobreza) = paste(pobreza[3,] |> as.vector() |>  zoo::na.locf(na.rm = T) |>  unlist() |>  as.character(), pobreza[4,]) |> 
  gsub(pattern = "*\r\n", replacement = " ") |>  gsub(pattern = "\r\n", replacement = " ") |>  
  gsub(pattern = "NA", replacement = " ") |> gsub(pattern = "Porcentaje 2020", replacement = "2020%") |> stringr::str_squish()


pobreza = pobreza |> 
  dplyr::filter(!is.na(Municipio)) |> 
  dplyr::slice(-1) |> 
  dplyr::select(-c(`Clave de entidad`:`Clave de municipio`, `Población 2020* (leer nota al final del cuadro)`))


pobreza |>  openxlsx::write.xlsx("Output/Drive/5. Pobreza.xlsx")
