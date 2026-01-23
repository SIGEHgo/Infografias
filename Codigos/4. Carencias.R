carencias = "Inputs/Drive/4. Carencias/Carencias Sociales por Municipio 2020.xlsx" |>  
  readxl::read_excel()


nombres = paste(carencias[3,] |> as.vector() |>  zoo::na.locf(na.rm = T) |>  unlist() |>  as.character(), carencias[4,]) |>  
  gsub(pattern = "\r\n", replacement = " ") |> gsub(pattern = "NA", replacement = " ") |>  stringr::str_squish()

names(carencias) = nombres 

carencias = carencias |>  dplyr::filter(!is.na(`Clave de municipio`)) |> 
  dplyr::slice(-1)


names(carencias) = names(carencias)  |>  gsub(pattern = "Porcentaje 2020", replacement = "2020%")
#names(carencias) = names(carencias)  |>  gsub(pattern = " 2020%", replacement = "%")

carencias = carencias |> 
  dplyr::select(-`Clave de entidad`, -`Entidad federativa`, -`Población 2020* (leer nota al final del cuadro)`, -`Clave de municipio`)


carencias |>  openxlsx::write.xlsx("Output/Drive/4. Carencias.xlsx")



 