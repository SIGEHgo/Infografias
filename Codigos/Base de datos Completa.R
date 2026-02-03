mun = "Output/Infografia_Base_Municipal_2026_Enero.xlsx" |> readxl::read_excel()

regional = "Output/Infografia_Base_Regional_2026_Enero.xlsx" |> readxl::read_excel()

metropolitana = "Output/Infografia_Base_Zona_Metropolitana_2026_Enero.xlsx" |> readxl::read_excel()

estatal = "Output/Infografia_Base_Estatal_2026_Enero.xlsx" |> readxl::read_excel()
  
referencias = "Output/Referencias_update.xlsx" |> readxl::read_excel()


openxlsx::write.xlsx(
  list(
    "Municipal" = mun,
    "Regional" = regional,
    "Metropolitana" = metropolitana,
    "Estatal" = estatal,
    "Referencias" = referencias
  ),
  file = "Output/Infografias Base Enero 2026.xlsx"
)
  