datos = "Inputs/Drive/11. Red Carretera/Longitud de la red carretera por municipio según tipo de camino y superficie.xlsx" |>  readxl::read_excel()

datos = datos |> 
  dplyr::select(
    dplyr::where(fn = ~ !all(is.na(.)))
  ) 

datos = datos |> 
  dplyr::select(-...2, -...4)
  

names(datos) = paste(
  datos[5,] |>  
  gsub(pattern = "a/", replacement = " ") |> 
  gsub(pattern = "b/", replacement = " ") |>  
  stringr::str_squish() |> 
  as.vector() |>  
  zoo::na.locf(na.rm = T) |>  
  unlist() |>  
  as.character(),
  datos[6,] |>
  gsub(pattern = "-\r\nda", replacement = "da"),
  sep = " "
) |> gsub(pattern = "NA", replacement = " ") |> 
  stringr::str_squish()


datos = datos |> 
  dplyr::select(-`Alimentadoras estatales c/`) |> 
  dplyr::filter(!is.na(Total)) |> 
  dplyr::slice(-c(1,2))


datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = Total:`Brechas mejoradas`,
      .fns = ~ as.numeric(.x)
    ) 
  )|> 
  dplyr::rename(`Longitud de la Red Carretera` = Total,
                `Carretras Federales` = `Troncal federal Pavimentada`
                ) |> 
  dplyr::mutate(
    `Alimentadoras Estatales` = `Alimentadoras estatales Revestida` + `Alimentadoras estatales Pavimentada`,
    `Caminos Rurales` = `Caminos rurales Revestida` + `Alimentadoras estatales Pavimentada`
  ) |> 
  dplyr::select(
    -`Alimentadoras estatales Pavimentada`, -`Alimentadoras estatales Revestida`, 
    -`Caminos rurales Pavimentada`, -`Caminos rurales Revestida`            
    ) |> 
  dplyr::relocate(
    `Brechas mejoradas`, 
    .after = dplyr::last_col()
  )

datos |>  openxlsx::write.xlsx("Output/Drive/11. Red Carretera.xlsx")



