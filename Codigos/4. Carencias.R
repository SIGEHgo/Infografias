carencias = "Inputs/Drive/4. Carencias/Carencias Sociales por Municipio 2020.xlsx" |>  
  readxl::read_excel()


nombres = paste(carencias[3,], carencias[4,]) |>  gsub(pattern = "\r\n", replacement = " ") |> gsub(pattern = "NA", replacement = " ") |> stringr::str_squish()
nombres[c(7,9,11,13,15,17)] = paste(carencias[3,][c(6,8,10,12,14,16)],nombres[c(7,9,11,13,15,17)] ) |> stringr::str_squish()

names(carencias) = nombres |> stringr::str_squish()


carencias = carencias |>  dplyr::filter(!is.na(`Clave de municipio`))
carencias = carencias[-1,]

names(carencias) = names(carencias)  |>  gsub(pattern = "Porcentaje 2020", replacement = "2020%")
#names(carencias) = names(carencias)  |>  gsub(pattern = " 2020%", replacement = "%")

carencias = carencias |> 
  dplyr::select(-`Clave de entidad`, -`Entidad federativa`, -`Población 2020* (leer nota al final del cuadro)`)


carencias |>  openxlsx::write.xlsx("Output/4. Carencias.xlsx")
