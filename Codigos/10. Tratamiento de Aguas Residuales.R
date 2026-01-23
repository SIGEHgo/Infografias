plantas = "Inputs/Drive/10. Tratamiento de Aguas Residuales/Plantas de tratamiento en operación, capacidad instalada y volumen.xlsx" |> 
  readxl::read_excel()

plantas = plantas |> 
  dplyr::select(`Plantas de tratamiento en operación, capacidad instalada y volumen tratado de aguas residuales por municipio y tipo de servicio según nivel de tratamiento`, 
                ...5, ...13)


plantas = plantas |> 
  dplyr::filter(!is.na(...5)) |> 
  dplyr::filter(`Plantas de tratamiento en operación, capacidad instalada y volumen tratado de aguas residuales por municipio y tipo de servicio según nivel de tratamiento` != "Privado" & `Plantas de tratamiento en operación, capacidad instalada y volumen tratado de aguas residuales por municipio y tipo de servicio según nivel de tratamiento` != "Público" ) |> 
  dplyr::slice(-c(1,2))


plantas = plantas |> 
  dplyr::rename(
    Municipio = `Plantas de tratamiento en operación, capacidad instalada y volumen tratado de aguas residuales por municipio y tipo de servicio según nivel de tratamiento`,
    `Plantas de tratamiento en operación, capacidad instalada y volumen tratado de aguas residuales por municipio y tipo de servicio según nivel de tratamiento`= ...5,
    `Volumen tratado   (Millones de metros cúbicos)` = ...13
  ) |> 
  dplyr::mutate(
    Municipio = Municipio |> stringr::str_squish()
  )


names(plantas) = names(plantas) |>  stringr::str_squish()

plantas |>  openxlsx::write.xlsx("Output/Drive/10. Tratamiento de Aguas Residuales.xlsx")

