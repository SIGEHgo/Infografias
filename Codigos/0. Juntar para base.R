archivos = list.files(path = "Output/Drive/", full.names = T)


prueba = archivos |>  as.data.frame()

prueba = prueba |> 
  dplyr::mutate(
    numero = archivos |>  basename()|> sub(pattern = "\\..*", replacement = "") |>  as.numeric()
  ) |> 
  dplyr::arrange(numero)


archivos = prueba$archivos
juntar = archivos[1] |>  readxl::read_excel()

for (i in 2:length(archivos)) {
  
  cat("Vamos en: ", archivos[i] |>  basename(), "\n")
  datos = archivos[i] |>  readxl::read_excel()
  
  juntar = juntar |> 
    dplyr::left_join(y = datos, by = c("CVE_MUN" = "CVE_MUN"))
}

juntar |>  openxlsx::write.xlsx("Output/Base_Sin_Operaciones_2025_Enero.xlsx")







##############
### Añadir ###
##############

datos = "Output/Base_Sin_Operaciones_2025_Enero.xlsx" |>  readxl::read_excel()
region = "Inputs/Ejemplo/Banco de datos infografias _Eduardo_2024.xlsx" |>  readxl::read_excel()

region = region |> 
  dplyr::select(Municipio:`Zona Metropolitana`) |> 
  dplyr::filter(!is.na(Región))



datos = datos |> 
  dplyr::left_join(y = region, by = c("Municipio" = "Municipio"))

datos = datos |> 
  dplyr::relocate(c(Región, `Zona Metropolitana`), .after = Municipio)

names(datos) = names(datos) |>  stringr::str_squish()

datos |>  openxlsx::write.xlsx("Output/Base_Sin_Operaciones_2025_Enero.xlsx")
