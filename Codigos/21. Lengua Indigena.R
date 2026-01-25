anios = "Inputs/Drive/21. Lenguas Indigenas/anios.xlsx" |>  readxl::read_excel(sheet = 3)

anios = anios |> 
  dplyr::filter(!is.na(...2)) |> 
  dplyr::select(`INEGI. Censo de Población y Vivienda 2020. Tabulados del Cuestionario Básico`:...6)

names(anios) = anios[1,] |>  stringr::str_squish()

anios = anios |> 
  dplyr::slice(-1) |> 
  dplyr::filter(Municipio != "Total" & Sexo == "Total" & `Grupos quinquenales de edad` == "Total") |> 
  dplyr::mutate(
    CVE_MUN = Municipio |>  substr(start = 1, stop = 3) |>  stringr::str_squish(),
    Municipio = Municipio |>  substr(start = 4, stop = nchar(Municipio)) |>  stringr::str_squish()
    ) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::rename(
    `Población de 3 años y más que habla alguna lengua indígena`= `Condición de habla indígena`
  ) |> 
  dplyr::select(CVE_MUN, Municipio, `Población de 3 años y más que habla alguna lengua indígena`)



considera = "Inputs/Drive/21. Lenguas Indigenas/Se considera.xlsx" |>  readxl::read_excel()

considera = considera |> 
  dplyr::select(...3,...4,...6,...7,...9,...10)

names(considera) = considera[3,]

considera = considera |> 
  dplyr::filter(Entidad == "Hidalgo" & Estimador == "Estimación" & Tipo == "Población") |> 
  dplyr::select(Municipio,`Se considera indígena`,`No se considera indígena`) |> 
  dplyr::mutate(
    Municipio = Municipio |> stringr::str_squish()
  )





lengua = "Inputs/Drive/21. Lenguas Indigenas/8-poblacion-indigena-en-hogares-segun-pueblo-por-municipio-censo-2020-100122.xlsx" |>  readxl::read_excel()

names(lengua) = lengua[2,]

lengua = lengua |> 
  dplyr::filter(ENTIDAD == "Hidalgo") |> 
  dplyr::select(MUNICIPIO, LENGUA, PIHOGARES) |> 
  dplyr::mutate(
    PIHOGARES = PIHOGARES |>  as.numeric()
  )
  
lengua = lengua |> 
  tidyr::pivot_wider(
    names_from = LENGUA,
    values_from = PIHOGARES,
    values_fill = 0
  )


datos = anios |> 
  dplyr::left_join(y = considera, by = c("Municipio" = "Municipio")) |> 
  dplyr::left_join(y = lengua , by = c("Municipio" = "MUNICIPIO"))


names(datos)[(names(datos) == "No especificado") |>  which()] = "No especificado lengua indigena"


datos |>  openxlsx::write.xlsx("Output/Drive/21. Lengua Indigena.xlsx")


