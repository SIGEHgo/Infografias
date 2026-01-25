unidades = "Inputs/Drive/19. Cultura/Unidades Deportivas.xlsx" |> 
  readxl::read_excel()

unidades = unidades |> 
  dplyr::select(
    -c(...2:...4)
  )

names(unidades) = unidades[4,] |>  stringr::str_squish()

unidades = unidades |> 
  dplyr::filter(!is.na(`Centros y unidades deportivas`)) |> 
  dplyr::slice(-c(1,2)) |> 
  dplyr::mutate(
    Municipio = Municipio |>  stringr::str_squish()
  )


bibliotecas = "Inputs/Drive/19. Cultura/Bibliotecas.xlsx" |>  
  readxl::read_excel() |> 
  dplyr::select(
    dplyr::where(fn = ~ !all(is.na(.)))
  ) 


bibliotecas = bibliotecas |> 
  dplyr::select(-c(...2, ...4, ...6, ...8, ...10, ...12))

names(bibliotecas) = bibliotecas[4,] |> 
  gsub(pattern = "-\r\n", replacement = "") |> 
  gsub(pattern = "\r\n", replacement = " ") |> 
  gsub(pattern = "-", replacement = "") |>  
  stringr::str_squish()

bibliotecas = bibliotecas |> 
  dplyr::filter(!is.na(`Bibliotecas públicas`)) |> 
  dplyr::slice(-c(1,2))  |> 
  dplyr::mutate(
    Municipio = Municipio |>  stringr::str_squish()
  )

names(bibliotecas)[3:ncol(bibliotecas)] = paste(names(bibliotecas)[3:ncol(bibliotecas)], "Bibliotecas")


datos = bibliotecas |> 
  dplyr::left_join(y = unidades, by = c("Municipio" = "Municipio"))




datos |>  openxlsx::write.xlsx("Output/Drive/19. Cultura.xlsx")
