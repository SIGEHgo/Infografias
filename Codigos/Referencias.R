datos = "Inputs/Banco de datos infografias _Eduardo.xlsx" |>  readxl::read_excel()

columnas = names(datos) |>  gsub(pattern = "_", replacement = " ")  |> gsub(pattern = "\r\n", replacement = " ") |> stringr::str_squish() |>  as.data.frame()
names(columnas) = "Variable"

columnas = columnas |> 
  dplyr::mutate(Categoria = "") |> 
  dplyr::relocate(Categoria, .before = Variable)|> 
  dplyr::mutate(
    Temporalidad = "",
    Link = "",
    Observaciones = "",
    Notas = "",
    Operacion = "",
    Variable = Variable |> stringr::str_squish()
  ) 

columnas = columnas[-c(1:3),]

columnas |>  openxlsx::write.xlsx("Output/Referencias.xlsx")



#########################################
### Ordemos manualmente las variables ###
#########################################

datos = "Output/Referencias.xlsx" |>  readxl::read_excel()


datos = datos |> 
  tidyr::fill(Categoria, .direction = "down")



datos |>  openxlsx::write.xlsx("Output/Referencias.xlsx")
