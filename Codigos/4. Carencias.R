carencias = "Inputs/Drive/4. Carencias/Carencias Sociales por Municipio 2020.xlsx" |>  
  readxl::read_excel()


paste(carencias[3,], carencias[4,]) |>  gsub(pattern = "\r\n", replacement = " ") |> 
  stringr::str_squish()

  
  
  gsub(pattern = "NA", replacement = "")