datos = readxl::read_xlsx("../../bases de datos practicas/cpv2020_b_hgo_01_poblacion.xlsx", sheet = 5)
library(readxl)

datos = readxl::read_excel("../../bases de datos practicas/cpv2020_b_hgo_01_poblacion.xlsx", sheet = 5)

datos = datos |>  dplyr::select(`INEGI. Censo de Población y Vivienda 2020. Tabulados del Cuestionario Básico`:...3) 

datos = datos |> dplyr::filter(!is.na(...2))

names(datos) = datos[1,]
datos = datos[-c(1,2),]

names(datos)[3] = "Población total"

datos = datos |>  
  dplyr::mutate(
    `Población total` = `Poblacion total` |>  as.numeric()
  )


datos = datos |> 
  dplyr::mutate(
    `Población total%` = (`Población total`/sum(`Población total`, na.rm = T))*100
  )





##### Extension del ejercicio de arriba

datos = readxl::read_excel("../../bases de datos practicas/cpv2020_b_hgo_01_poblacion.xlsx", sheet = 5)

datos = datos |>  dplyr::select(`INEGI. Censo de Población y Vivienda 2020. Tabulados del Cuestionario Básico`:...5)

datos = datos |>  dplyr::filter(!is.na(...2))

names(datos) = datos[1,]

names(datos)[c(3:5)] = c("Población total", "Hombre", "Mujer")

datos = datos[-c(1,2),]

datos = datos |> 
  dplyr::mutate(
    `Población total` = `Población total` |>  as.numeric(),
    Hombre = Hombre |>  as.numeric(),
    Mujer = Mujer |>  as.numeric()
  )


datos = datos |> 
  dplyr::mutate(
    `Población total%` = (`Población total`/sum(`Población total`, na.rm = T))*100,
    `Hombre%` = (Hombre/sum(Hombre, na.rm = T))*100,
    `Mujer%` = (Mujer/sum(Mujer, na.rm = T))*100
  )

datos = datos |> 
  dplyr::relocate(`Población total%`, .after = `Población total`) |> 
  dplyr::relocate(`Hombre%`, .after = Hombre)
#####################pra separar columnas y el string para eliminar espacios
datos_lalo = datos |> 
  dplyr::mutate(
    CVEGEO = paste0("13", Municipio |> substr(start = 1,stop = 3)) |>  stringr::str_squish(),
    Municipio = Municipio |>  substr(start = 4, stop = nchar(Municipio)) |>  stringr::str_squish()
  )


