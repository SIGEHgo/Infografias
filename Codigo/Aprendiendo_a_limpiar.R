datos = read_xlsx("../../bases de datos practicas/cpv2020_b_hgo_01_poblacion.xlsx", sheet = 5)

names(datos) = datos[5,]
datos1=datos[8:nrow(datos),1:ncol(datos)]

install.packages("tydir" )


datos2 = datos |>  
  dplyr::filter(!is.na(...2)) |>  
  dplyr::select(`INEGI. Censo de Población y Vivienda 2020. Tabulados del Cuestionario Básico`:...5)


names(datos2) = datos2[1,]

names(datos2)[4:5] = c("Hombre", "Mujer")

datos2 = datos2[-c(1:2),]


dplyr::left_join()
datos3= datos |>  dplyr::filter(is.na(...2))
datos4=datos |> dplyr::filter(!is.na(...2)) 



