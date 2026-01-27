datos = "Output/Infografia_Base_Municipal_2026_Enero.xlsx" |> readxl::read_excel()



h1 =  c(
  "Municipio",
  "Superficie (km2)",
  "Densidad de población (hab./km2)",
  "Población total",
  "Población total%",
  "Población Rural",
  "Población Rural%",
  "Población Urbana",
  "Población Urbana%",
  "Población Mujeres",
  "Población Mujeres%",
  "Población Hombres",
  "Población Hombres%",
  "Población infantil (0-14 años)",
  "Población infantil (0-14 años)%",
  "Población juvenil (15-29 años)",
  "Población juvenil (15-29 años)%",
  "Población (18 años y más)",
  "Población (18 años y más)%",
  "Población adulta (30-59 años)",
  "Población adulta (30-59 años)%",
  "Población adulta mayor (60 y más años)",
  "Población adulta mayor (60 y más años)%",
  "Población con discapacidad, limitación o con algún problema o condición mental",
  "Población de 3 años y más que habla alguna lengua indígena",
  "Usuarios de los Servicios de Salud",
  "Personal médico de las dependencias del sector público de salud por municipio",
  "Unidades médicas en servicio de las dependencias del sector público de salud por municipio",
  "Viviendas particulares habitadas",
  "% Viviendas particulares con hacinamiento",
  "Promedio de ocupantes por vivienda",
  "Porcentaje de viviendas sin agua entubada",
  "Porcentaje de viviendas sin sanitario ni drenaje",
  "Porcentaje de viviendas sin energía eléctrica",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Televisor%",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Computadora, laptop o tablet%",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Línea telefónica fija%",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Teléfono celular%",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Internet%",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Servicio de televisión de paga (Cable o satelital)%",
  "Rezago educativo 2020%",
  "Carencia por acceso a los servicios de salud 2020%",
  "Carencia por acceso a la alimentación 2020%",
  "Carencia por acceso a la seguridad social 2020%",
  "Carencia por calidad y espacios de la vivienda 2020%",
  "Carencia por acceso a los servicios básicos en la vivienda 2020%",
  "Pobreza 2020%",
  "Pobreza Personas 2020",
  "Pobreza extrema 2020%",
  "Pobreza extrema Personas 2020",
  "Vulnerables por ingreso 2020%",
  "Vulnerables por ingreso Personas 2020"
)



hoja1 = datos |> 
  dplyr::select(dplyr::any_of(h1))



hoja1 |>  openxlsx::write.xlsx("../../../../hoja1.xlsx")
