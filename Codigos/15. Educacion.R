educacion = "Inputs/Drive/15. Educacion/Educación.xlsx" |>  readxl::read_excel()

educacion = educacion |> 
  dplyr::filter(!is.na(...2)) |> 
  dplyr::mutate(
    ...2 = dplyr::if_else(condition = !is.na(...1), true = ...1, false = ...2)
  )

educacion$...2[which(educacion$...1 == educacion$...2)] = "Total"

educacion = educacion |> 
  tidyr::fill(...1, .direction = "down") |> 
  dplyr::mutate(
    ...1 = ...1 |>  as.numeric() |> sprintf(fmt = "%03d"),
    ...1 = paste0("13",...1) |> stringr::str_squish()
  )


educacion = educacion |> 
  tidyr::pivot_wider(
    names_from = ...2,
    values_from = Escuelas:Docentes,
    names_sep = " ",
    values_fill = 0
  )

educacion = educacion |> 
  dplyr::rename(
    CVE_MUN = ...1  
  )


educacion |>  openxlsx::write.xlsx("Output/Drive/15. Educacion.xlsx")
