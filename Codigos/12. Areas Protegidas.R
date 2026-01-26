datos = "Inputs/Drive/12. Areas Protegidas/Areas Protegidas.xlsx" |>  readxl::read_excel()

datos = datos |> 
  dplyr::rename(CVE_MUN = Cve_Mpal) |> 
  dplyr::mutate(
    CVE_MUN = paste0("13", CVE_MUN) |>  stringr::str_squish(),
    `Nombres áreas protegida` = `Nombres áreas protegida` |>  stringr::str_squish()
  )


datos |>  openxlsx::write.xlsx("Output/Drive/12. Areas Protegidas.xlsx")
