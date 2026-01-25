liconsa = "Inputs/Drive/16. Comercio/Liconsa.xlsx" |>  
  readxl::read_excel() |>  
  dplyr::select(
    dplyr::where(fn = ~ !all(is.na(.)))
  ) 


liconsa = liconsa |> 
  dplyr::select(-c(...2:...4))

names(liconsa) = liconsa[4,]  |>   gsub(pattern = "- ", replacement = "")  |>  stringr::str_squish()


liconsa = liconsa |> 
  dplyr::select(-c(`a/`, `b/`))

liconsa = liconsa |> 
  dplyr::rename(
    `Puntos de atención` =  `Puntos de aten- ción`,
    `Familias beneficiarias` = `Familias benefi- ciarias`,
    `Dotación anual de leche fortificada (Litros)` = `Dotación anual de leche fortifica- da (Litros)`,
    `Importe de la venta de leche fortificada (Miles de pesos)` = `Importe de la ven- ta de leche fortifi- cada (Miles de pesos)`
  )



liconsa = liconsa |> 
  dplyr::filter(!is.na(`Puntos de atención`)) |> 
  dplyr::slice(-c(1,2)) |> 
  dplyr::mutate(
    Municipio = Municipio |>  stringr::str_squish()
  )

names(liconsa)[2:ncol(liconsa)] = paste(names(liconsa)[2:ncol(liconsa)], "LICONSA") 

unidades = "Inputs/Drive/16. Comercio/Unidades.xlsx" |> 
  readxl::read_excel() |>  
  dplyr::select(
    dplyr::where(fn = ~ !all(is.na(.)))
  ) 


unidades = unidades |> 
  dplyr::select(-c(...2,...4,...7)) |> 
  dplyr::filter(!is.na(...5)) 

names(unidades) = unidades[1,] |> stringr::str_squish()

unidades = unidades |> 
  dplyr::slice(-c(1,2)) |> 
  dplyr::mutate(
    Municipio = Municipio |> stringr::str_squish()
  )


gasolinerias = "Inputs/Drive/16. Comercio/Gasolinerias.xlsx" |>  readxl::read_excel()

gasolinerias = gasolinerias |> 
  dplyr::select(-c(...2, ...3, ...4, ...7)) |> 
  dplyr::filter(!is.na(...5))

names(gasolinerias) = gasolinerias[1,] |> stringr::str_squish()

gasolinerias = gasolinerias |> 
  dplyr::slice(-c(1,2)) |> 
  dplyr::mutate(
    Municipio = Municipio |> stringr::str_squish()
  )

names(gasolinerias)[2:ncol(gasolinerias)] = paste(names(gasolinerias)[2:ncol(gasolinerias)], "Gasolinerias")


###
datos = liconsa |> 
  dplyr::left_join(y = unidades, by = c("Municipio" = "Municipio")) |> 
  dplyr::left_join(y = gasolinerias, by = c("Municipio" = "Municipio"))


datos |>  openxlsx::write.xlsx("Output/Drive/16. Comercio.xlsx")



