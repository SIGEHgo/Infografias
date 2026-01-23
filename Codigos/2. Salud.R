list.files(path = "Inputs/Drive/2. Salud/", full.names = T)

usuarios = "Inputs/Drive/2. Salud/Usuarios de los Servicios de Salud.xlsx" |> readxl::read_excel()
usuarios = usuarios |> 
  dplyr::select(`Población usuaria de los servicios médicos de las dependencias del sector público de salud por municipio de atención al usuario según institución`, ...5) |> 
  dplyr::filter(!is.na(...5)) |> 
  dplyr::rename(Municipio = `Población usuaria de los servicios médicos de las dependencias del sector público de salud por municipio de atención al usuario según institución`) |> 
  dplyr::rename(`Usuarios de los Servicios de Salud`= ...5) |> 
  dplyr::mutate(
    Municipio = Municipio |>  gsub(pattern = "a/", replacement = " ") |> stringr::str_squish()
    )
usuarios = usuarios[3:86,]

unidades = "Inputs/Drive/2. Salud/Unidades médicas en servicio de las dependencias del sector público de salud por municipio.xlsx" |>  readxl::read_excel()
unidades = unidades |> 
  dplyr::select(`Unidades médicas en servicio de las dependencias del sector público de salud por municipio y nivel de atención según institución`, ...5) |> 
  dplyr::filter(!is.na(...5)) |> 
  dplyr::mutate(`Unidades médicas en servicio de las dependencias del sector público de salud por municipio y nivel de atención según institución` = `Unidades médicas en servicio de las dependencias del sector público de salud por municipio y nivel de atención según institución`|> gsub(pattern = "a/", replacement = " ") |> stringr::str_squish()) |> 
  dplyr::filter(! `Unidades médicas en servicio de las dependencias del sector público de salud por municipio y nivel de atención según institución` %in% c("De consulta externa", "De hospitalización general", "De hospitalización especializada")) |> 
  dplyr::rename(Municipio = `Unidades médicas en servicio de las dependencias del sector público de salud por municipio y nivel de atención según institución`) |> 
  dplyr::rename(`Unidades médicas en servicio de las dependencias del sector público de salud por municipio`= ...5)

unidades = unidades[3:86,]

personal = "Inputs/Drive/2. Salud/Personal médico de las dependencias del sector público de salud por municipio.xlsx" |>  readxl::read_excel()

personal = personal |> 
  dplyr::select(`Personal médico de las dependencias del sector público de salud por municipio según institución`, ...5) |> 
  dplyr::filter(!is.na(...5)) |> 
  dplyr::mutate(`Personal médico de las dependencias del sector público de salud por municipio según institución` = `Personal médico de las dependencias del sector público de salud por municipio según institución` |>  gsub(pattern = "a/", replacement = " ") |> stringr::str_squish()) |> 
  dplyr::rename(Municipio = `Personal médico de las dependencias del sector público de salud por municipio según institución`) |> 
  dplyr::rename(`Personal médico de las dependencias del sector público de salud por municipio` = ...5)

personal = personal[-c(1:2),]


discapacidad = "Inputs/Drive/2. Salud/Población con discapacidad, limitación o con algún problema o condición mental.xlsx" |>  readxl::read_excel(sheet = 3)

discapacidad = discapacidad |> 
  dplyr::select(`INEGI. Censo de Población y Vivienda 2020. Tabulados del Cuestionario Básico`:...4, ...6) |> 
  dplyr::filter(...3 == "Total" & ...4 == "Total") |> 
  dplyr::slice(-1) |> 
  dplyr::mutate(
    ...2 = ...2 |>  substr(start = 4, stop = nchar(...2 )) |>  stringr::str_squish()
  ) |> 
  dplyr::select(...2, ...6) |> 
  dplyr::rename(Municipio = ...2) |> 
  dplyr::rename(`Población con discapacidad, limitación o con algún problema o condición mental` = ...6)




salud = usuarios |> 
  dplyr::left_join(y = unidades, by = c("Municipio" = "Municipio")) |> 
  dplyr::left_join(y = personal, by = c("Municipio" = "Municipio")) |> 
  dplyr::left_join(y = discapacidad, by = c("Municipio" = "Municipio"))

salud |>  openxlsx::write.xlsx("Output/Drive/2. Salud.xlsx")




