datos = "../../../../2025_dic2025__1_ (1).xlsx" |>  readxl::read_excel()


datos = datos |> 
  dplyr::mutate(
    `Tipo de delito` = dplyr::if_else(
      condition = `Tipo de delito` == "Robo", 
      true = `Subtipo de delito`,
      false = `Tipo de delito`
      )
    )

datos = datos |> 
  dplyr::filter(Entidad == "Hidalgo") |> 
  dplyr::group_by(`Cve. Municipio`,Municipio, `Tipo de delito`) |>
  dplyr::summarise(
    dplyr::across(
      .cols = Enero:Diciembre, 
      .fns = ~sum(.x, na.rm = TRUE)
      )
  ) |>  
  dplyr::ungroup()
  


datos = datos |>
  dplyr::mutate(
    Total = rowSums(dplyr::across(Enero:Diciembre), na.rm = TRUE)
  )


datos = datos |> 
  dplyr::select(`Cve. Municipio`:`Tipo de delito`, Total)


datos = datos |> 
  tidyr::pivot_wider(names_from = `Tipo de delito`, values_from = Total)

datos = datos |> 
  dplyr::mutate(
    `Total de delitos` =  rowSums(dplyr::across(Aborto:`Violencia familiar`), na.rm = TRUE)
  ) |>  
  dplyr::relocate(`Total de delitos`, .after = Municipio)



datos = datos |> 
  dplyr::relocate(Homicidio, .after = `Total de delitos`) |> 
  dplyr::relocate(Secuestro, .after = Homicidio) |> 
  dplyr::relocate(Lesiones, .after = Secuestro) |> 
  dplyr::relocate(Extorsión, .after = Lesiones) |> 
  dplyr::relocate(Feminicidio, .after = Extorsión) |> 
  dplyr::relocate(Narcomenudeo, .after = Feminicidio) |> 
  dplyr::relocate(`Robo a casa habitación`, .after = Narcomenudeo) |> 
  dplyr::relocate(`Robo de vehículo automotor`, .after = `Robo a casa habitación`) |> 
  dplyr::relocate(`Robo a negocio`, .after = `Robo de vehículo automotor`) |>
  dplyr::relocate(`Violación simple`, .after = `Robo a negocio`) |> 
  dplyr::relocate(`Violación equiparada`, .after = `Violación simple`) |> 
  dplyr::relocate(`Violencia familiar`, .after = `Violación equiparada`)


datos = datos |> 
  dplyr::mutate(
    `Otros delitos` = rowSums(dplyr::across(Aborto:`Violencia de género en todas sus modalidades distinta a la violencia familiar`), na.rm = TRUE)
  ) |> 
  dplyr::relocate(`Otros delitos`, .after = `Violencia familiar`)


datos = datos |> 
  dplyr::select(`Cve. Municipio`:`Otros delitos`)

datos = datos |> 
  dplyr::rename(Violación = `Violación simple`) |> 
  dplyr::mutate(
    Violación = Violación + `Violación equiparada`
  ) |> 
  dplyr::select(-`Violación equiparada`) |> 
  dplyr::relocate(Violación, .after = `Robo a negocio`)



datos |>  openxlsx::write.xlsx("Output/9. Incidencia delictiva.xlsx")
