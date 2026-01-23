vivienda = "Inputs/Drive/3. Vivienda/Vivienda.xlsx" |>  readxl::read_excel(sheet = 19)

names(vivienda) = vivienda[5,]

vivienda = vivienda |> 
  dplyr::filter(!is.na(Municipio)) |> 
  dplyr::slice(-c(1,2)) |> 
  dplyr::mutate(
    Municipio = Municipio |> substr(start = 4, stop = nchar(Municipio)) |> stringr::str_squish()
  ) |> 
  dplyr::select(-`Entidad federativa`)








vivienda_deficit = "Inputs/Drive/3. Vivienda/Vivienda.xlsx" |>  readxl::read_excel(sheet = 15)
names(vivienda_deficit)

names(vivienda_deficit)[1:4] = vivienda_deficit[5,][1:4]
names(vivienda_deficit)[5:7] = paste(vivienda_deficit[6,][5:7] |> as.vector() |>  zoo::na.locf(na.rm = T) |>  unlist() |>  as.character(), vivienda_deficit[7,][5:7])

vivienda_deficit = vivienda_deficit |> 
  dplyr::filter(!is.na(Municipio) & Municipio != "Total") |> 
  dplyr::slice(-1) |> 
  dplyr::select(`Entidad federativa`:`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado`)
  

vivienda_deficit = vivienda_deficit |> tidyr::pivot_wider(
  names_from = `Bienes y tecnologías de la información y de la comunicación`,
  values_from = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen`:`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado`,
  names_sep = " "
)


vivienda_deficit = vivienda_deficit |> 
  dplyr::select(-`Entidad federativa`) |> 
  dplyr::mutate(
    Municipio = Municipio |>  substr(start = 4, stop = nchar(Municipio)) |>  stringr::str_squish()
  )


hacinamiento = "Inputs/Drive/3. Vivienda/Hacinamiento.xlsx" |>  readxl::read_excel()
names(hacinamiento) = hacinamiento[3,]

hacinamiento = hacinamiento |> 
  dplyr::select(`Nombre de la entidad`, `Nombre del municipio`, `% Viviendas particulares con hacinamiento`) |> 
  dplyr::filter(`Nombre de la entidad` == "Hidalgo") |> 
  dplyr::filter(!is.na(`Nombre del municipio`)) |> 
  dplyr::select(-`Nombre de la entidad`) |> 
  dplyr::mutate(`Nombre del municipio` = `Nombre del municipio` |>  stringr::str_squish())


vivienda = vivienda |> 
  dplyr::left_join(y = vivienda_deficit |>  dplyr::select(-`Viviendas particulares habitadas`), by = c("Municipio" = "Municipio")) |> 
  dplyr::left_join(y = hacinamiento, by = c("Municipio" = "Nombre del municipio"))



vivienda |>  openxlsx::write.xlsx("Output/Drive/3. Vivienda.xlsx")

# prueba = vivienda_deficit |> 
#   dplyr::mutate(
#     dplyr::across(
#       .cols = `Viviendas particulares habitadas`:
#         `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Consola de videojuegos`,
#       .fns = ~ as.numeric(.x)
#     ),
#     dplyr::across(
#       .cols = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Refrigerador`:
#         `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Consola de videojuegos`,
#       .fns = ~ (.x / .data[["Viviendas particulares habitadas"]]) * 100,
#       .names = "{.col}%"
#     )
#   )
# 
# 
# prueba = prueba |> 
#   dplyr::select(Municipio,
#                 `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Televisor`,
#                 `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Televisor%`,
#                 `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Televisor`,
#                 `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Televisor%`,
#                 `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Televisor`,
#                 `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Televisor%`)
