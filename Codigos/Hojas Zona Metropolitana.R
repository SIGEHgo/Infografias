datos = "Output/Infografias Base Enero 2026.xlsx" |> readxl::read_excel(sheet = 3)

datos = datos |> 
  dplyr::filter(
    `Zona Metropolitana` != "Otros"
  )

columnas = names(datos) |>  as.data.frame()

################################
### Los que son NA pasar a 0 ###
################################

datos = datos |> 
  dplyr::rename(
    `Trabajadores del sector Terciario(Servicios)%` = `Trabajadores del sector Terciario(Servicios)`
  )

datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = c(`Superficie (km2)`:`Número de áreas protegidas`, 
                `Cantidad promedio diaria de residuos sólidos urbanos recolectados`:`Grado promedio de escolaridad`,
                `Población de 15 años y más`:`Índice de marginación 2020`,
                `Indice de migracición 2020`,
                `Total Hospedajes`:`Popoluca insuficientemente especificado`,
                `Lenguas Indigenas Top 5 Conteo`,
                `Lengua Indigena más hablada conteo 1`:`Lengua Indigena más hablada conteo 5`), 
      .fns = ~ dplyr::if_else(is.na(.x), 0, .x)
    )  
  )


datos = datos |> 
  dplyr::mutate(
    `Nombres áreas protegida` = dplyr::if_else(condition = is.na(`Nombres áreas protegida`),
                                               true = "No cuenta",
                                               false = `Nombres áreas protegida`)
  )



############################
### Darle formato bonito ###
############################

datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = c(`Superficie (km2)`:`Número de áreas protegidas`, 
                `Cantidad promedio diaria de residuos sólidos urbanos recolectados`:`Grado promedio de escolaridad`,
                `Población de 15 años y más`:`Índice de marginación 2020`,
                `Indice de migracición 2020`,
                `Total Hospedajes`:`Popoluca insuficientemente especificado`,
                `Lenguas Indigenas Top 5 Conteo`,
                `Lengua Indigena más hablada conteo 1`:`Lengua Indigena más hablada conteo 5`
      ), 
      .fns = ~ .x  |> 
        round(digits = 2) |> 
        formatC(format = "f", big.mark = ",", drop0trailing = T)
    )  
  )





columnas_porcentajes = names(datos) |>  as.data.frame()
names(columnas_porcentajes) = "Columnas"

columnas_porcentajes = columnas_porcentajes |> 
  dplyr::filter(grepl("%", Columnas) | grepl("Porcentaje", Columnas))

columnas_porcentajes = columnas_porcentajes$Columnas


datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = dplyr::any_of(columnas_porcentajes), 
      .fns = ~ paste0(.x,"%")  
    )  
  )


datos = datos |> 
  dplyr::mutate(
    `Lengua Indigena más hablada 5` = dplyr::if_else(condition = is.na(`Lengua Indigena más hablada 5`), true = "", false = `Lengua Indigena más hablada 5`),
    `Lengua Indigena más hablada conteo 5` = dplyr::if_else(condition = `Lengua Indigena más hablada conteo 5` == 0, true = "", false = `Lengua Indigena más hablada conteo 5`)
  )



h1 =  c(
  "Zona Metropolitana",
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
  "Población de 3 años y más que habla alguna lengua indígena",
  "Se considera indígena",
  "Lenguas Indigenas Top 5",
  "Usuarios de los Servicios de Salud",
  "Personal médico de las dependencias del sector público de salud por municipio",
  "Población con discapacidad, limitación o con algún problema o condición mental",
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



hoja1 |>  openxlsx::write.xlsx("../../../../Zona Metropolitana hoja 1.xlsx")


############################################################
############################################################
############################################################


h2 = c(
  "Zona Metropolitana",
  "Seguridad Total",
  "Seguridad Total Hombres",
  "Seguridad Total Mujeres",
  "Procedimientos Administrativos",
  "Procedimientos Administrativos A disposición de la guardia nacional",
  "Procedimientos Administrativos A disposición de la policia estatal",
  "Procedimientos Administrativos A disposición de la policia municipal",
  "Centros Penitenciarios",
  "Centros de Reinserción",
  "Centro Femenil de Reiserción Social",
  "Población Penitenciaria Hombres",
  "Población Penitenciaria Mujeres",
  "Total de delitos",
  "Homicidio",
  "Secuestro",
  "Lesiones",
  "Extorsión",
  "Feminicidio",
  "Narcomenudeo",
  "Robo a casa habitación",
  "Robo de vehículo automotor",
  "Robo a negocio",
  "Violación",
  "Violencia familiar",
  "Otros delitos",
  "Tiendas Diconsa",
  "Tianguis",
  "Mercados públicos",
  "Centrales de abasto",
  "Estaciones de servicio Gasolinerias",
  "Puntos de atención LICONSA",
  "Familias beneficiarias LICONSA",
  "Beneficiarios LICONSA",
  "Dotación anual de leche fortificada (Litros) LICONSA"
)

hoja2 = datos |> 
  dplyr::select(dplyr::any_of(h2))


hoja2 |>  openxlsx::write.xlsx("../../../../Zona Metropolitana hoja 2.xlsx")


############################################################
############################################################
############################################################


h3 = c(
  "Zona Metropolitana",
  "Plantas de tratamiento en operación, capacidad instalada y volumen tratado de aguas residuales por municipio y tipo de servicio según nivel de tratamiento",
  "Volumen tratado (Millones de metros cúbicos)",
  "Longitud de la Red Carretera",
  "Carretras Federales",
  "Alimentadoras Estatales",
  "Caminos Rurales",
  "Brechas mejoradas",
  "Escuelas Total",
  "Escuelas Educación Preescolar",
  "Escuelas Educación Primaria",
  "Escuelas Educación Secundaria",
  "Escuelas Educación Media Superior",
  "Escuelas Educación Superior",
  "Alumnos Total",
  "Alumnos Educación Preescolar",
  "Alumnos Educación Primaria",
  "Alumnos Educación Secundaria",
  "Alumnos Educación Media Superior",
  "Alumnos Educación Superior",
  "Docentes Total",
  "Docentes Educación Preescolar",
  "Docentes Educación Primaria",
  "Docentes Educación Secundaria",
  "Docentes Educación Media Superior",
  "Docentes Educación Superior",
  "Grado promedio de escolaridad",
  "Grado promedio de escolaridad Equivalencia",
  "Poblacion Analfabeta%",
  "Desayunos Integrados",
  "Uniformes",
  "Becas",
  "Hoteles",
  "Moteles",
  "Pensiones y casas de huéspedes",
  "Cabañas, villas y similares",
  "Departamentos y casas amuebladas con servicio de hotelería",
  "Restaurantes",
  "Servicios de preparación de otros alimentos para consumo inmediato",
  "Cafeterías, fuentes de sodas, neverías, refresquerías y similares",
  "Bares, cantinas y similares",
  "Centros nocturnos, discotecas y similares"
)

hoja3 = datos |> 
  dplyr::select(dplyr::any_of(h3))

hoja3 |>  openxlsx::write.xlsx("../../../../Zona Metropolitana hoja 3.xlsx")





#####################
#####################
#####################


h4 = c(
  "Zona Metropolitana",
  
  "Población económicamente activa Total Total",
  "Población económicamente activa Ocupada Total",
  "Población económicamente activa Ocupada Hombres%",
  "Población económicamente activa Ocupada Mujeres%",
  "Población económicamente activa Desocupada Total",
  "Unidades Económicas",
  "Unidades Económicas Personal Ocupado",
  "Unidades Económicas Producción bruta total (millones de pesos)",
  "Trabajadores del Sector Primario%",
  "Trabajadores en el Sector secundario%",
  "Trabajadores del sector Terciario(Comercio)%",
  "Trabajadores del sector Terciario(Servicios)%",
  "Ingresos por remesas Enero-Septiembre(2025)",
  "Ingresos por remesas Enero-Septiembre(2025)%",
  "Intensidad de migración 2020",
  
  "Superficie Sembrada (has.)",
  "Superficie Cosechada (has)",
  "Volumen de la Producción (tons)",
  "Valor de la Producción (miles de pesos)",
  
  "Bibliotecas públicas",
  "Centros y unidades deportivas",
  
  
  "Maíz grano (Tonelada) Valor de la Producción",
  "Maíz grano (Tonelada) Volumen de la Producción",
  "Frijol (Tonelada) Valor de la Producción",
  "Frijol (Tonelada) Volumen de la Producción",
  "Avena forrajera en verde (Tonelada) Valor de la Producción",
  "Avena forrajera en verde (Tonelada) Volumen de la Producción",
  "Alfalfa (Tonelada) Valor de la Producción",
  "Alfalfa (Tonelada) Volumen de la Producción",
  "Maguey pulquero (Miles de lts.) Valor de la Producción",
  "Maguey pulquero (Miles de lts.) Volumen de la Producción",
  
  "Producción en toneladas de ganado en pie de tipo bovino",
  "Valor de la producción en miles de pesos de ganado en pie de tipo bovino",
  "Producción en toneladas de ganado en pie de tipo porcino",
  "valor de la producción en miles de pesos de ganado en pie de tipo porcino",
  "Producción en toneladas de ganado en pie de tipo ovino",
  "Valor de la producción en miles de pesos de ganado en pie de tipo ovino",
  "Producción en toneladas de ganado en pie de tipo caprino",
  "Valor de la producción en miles de pesos de ganado en pie de tipo caprino",
  "Producción en toneladas de aves en pie",
  "Valor de la producción en miles de pesos de aves en pie",
  "Producción en toneladas de guajolotes en pie",
  "Valor de la producción en miles de pesos de guajolotes en pie",
  
  "Producción de leche en miles de litros de ganado de tipo bovino",
  "Valor de la producción de leche en miles de pesos de ganado de tipo bovino",
  
  "Producción de huevo para plato en miles de litros",
  "Valor de la producción de huevo para plato en miles de pesos"
)



hoja4 = datos |> 
  dplyr::select(dplyr::any_of(h4))


hoja4 |> openxlsx::write.xlsx("../../../../Zona Metropolitana hoja 4.xlsx")
