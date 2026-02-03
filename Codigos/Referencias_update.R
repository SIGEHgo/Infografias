datos = "Output/Infografia_Base_Municipal_2026_Enero.xlsx" |>  readxl::read_excel()

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

columnas = columnas[-c(1:4),]


columnas |>  openxlsx::write.xlsx("Output/Referencias_update.xlsx")







referencias = "Output/Referencias_update.xlsx" |>  readxl::read_excel()

referencias = referencias |> 
  tidyr::fill(Categoria, .direction = "down")


referencias |>  openxlsx::write.xlsx("Output/Referencias_update.xlsx")
