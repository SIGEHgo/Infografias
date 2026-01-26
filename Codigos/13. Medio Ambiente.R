datos = "Inputs/Drive/13. Medio Ambiente/Residuos Solidos Urbanos.xlsx" |>  
  readxl::read_excel(sheet = 6) |>  
  dplyr::select(
    dplyr::where(fn = ~ !all(is.na(.)))
  )


names(datos) = paste(
  datos[4,] |>  
    as.vector() |>  
    zoo::na.locf(na.rm = T) |>  
    unlist() |>  
    as.character(),
  datos[5,],
  sep = " "
) |> gsub(pattern = "NA", replacement = " ") |> 
  stringr::str_squish()



datos = datos |> 
  dplyr::filter(`Entidad federativa` == "Hidalgo" & !is.na(`Municipio/ Demarcación territorial`))


datos = datos |> 
  dplyr::mutate(
    `Clave Municipio o demarcación` = paste0("13", `Clave Municipio o demarcación` |>  stringr::str_pad(width = 3, side = "left", pad = "0")) |>  stringr::str_squish() 
    ) |> 
  dplyr::select(-`Clave Entidad`, -`Entidad federativa`) |> 
  dplyr::rename(CVE_MUN = `Clave Municipio o demarcación`)



datos |>  openxlsx::write.xlsx("Output/Drive/13. Medio Ambiente.xlsx")


