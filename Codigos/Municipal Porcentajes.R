datos = "Output/Infografia_Base_Municipal_Sin_Operaciones_2026_Enero.xlsx" |>  readxl::read_excel()

columnas = names(datos) |>  as.data.frame()

### Pasar a numericos

datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = c(`Superficie (km2)`:`Número de áreas protegidas`, 
                `Cantidad promedio diaria de residuos sólidos urbanos recolectados`:`Grado promedio de escolaridad`,
                `Población de 15 años y más`:`Índice de marginación 2020`,
                `Indice de migracición 2020`,
                `Total Hospedajes`:`Popoluca insuficientemente especificado`), 
      .fns = ~ .x |>  as.numeric()
    )  
  )


### Para columnas que tienen error  buscar como usar tryCatch

###################
### Porcentajes ###
####################

poblacion_total = c(
  "Población Rural",
  "Población Urbana",
  "Población Mujeres",
  "Población Hombres",
  "Población infantil (0-14 años)",
  "Población juvenil (15-29 años)",
  "Población (18 años y más)",
  "Población adulta (30-59 años)",
  "Población adulta mayor (60 y más años)"
)


datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = dplyr::any_of(poblacion_total),
      .fns = ~ (.x /`Población total`)*100,
      .names = "{.col}%"
    )
  )



for (i in seq_along(poblacion_total)) {
  cat(
    "dplyr::relocate(`",
    paste0(poblacion_total[i], "%"),
    "`, .after = `",
    poblacion_total[i],
    "`) |> \n",
    sep = ""
  )
}


datos = datos |> 
  dplyr::relocate(`Población Rural%`, .after = `Población Rural`) |> 
  dplyr::relocate(`Población Urbana%`, .after = `Población Urbana`) |> 
  dplyr::relocate(`Población Mujeres%`, .after = `Población Mujeres`) |> 
  dplyr::relocate(`Población Hombres%`, .after = `Población Hombres`) |> 
  dplyr::relocate(`Población infantil (0-14 años)%`, .after = `Población infantil (0-14 años)`) |> 
  dplyr::relocate(`Población juvenil (15-29 años)%`, .after = `Población juvenil (15-29 años)`) |> 
  dplyr::relocate(`Población (18 años y más)%`, .after = `Población (18 años y más)`) |> 
  dplyr::relocate(`Población adulta (30-59 años)%`, .after = `Población adulta (30-59 años)`) |> 
  dplyr::relocate(`Población adulta mayor (60 y más años)%`, .after = `Población adulta mayor (60 y más años)`) 




###################################################
### Respecto a viviendas particulares habitadas ###
###################################################

datos$`Viviendas particulares habitadas`


viviendas_particulares = c(
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Refrigerador",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Lavadora",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Horno de microondas",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Automóvil o camioneta",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Motocicleta o motoneta",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Bicicleta que se utilice como medio de transporte",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Algún aparato o dispositivo para oír radio",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Televisor",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Computadora, laptop o tablet",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Línea telefónica fija",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Teléfono celular",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Internet",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Servicio de televisión de paga (Cable o satelital)",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Servicio de películas, música o videos de paga por Internet",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Consola de videojuegos",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Refrigerador",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Lavadora",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Horno de microondas",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Automóvil o camioneta",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Motocicleta o motoneta",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Bicicleta que se utilice como medio de transporte",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Algún aparato o dispositivo para oír radio",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Televisor",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Computadora, laptop o tablet",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Línea telefónica fija",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Teléfono celular",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Internet",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Servicio de televisión de paga (Cable o satelital)",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Servicio de películas, música o videos de paga por Internet",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Consola de videojuegos",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Refrigerador",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Lavadora",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Horno de microondas",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Automóvil o camioneta",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Motocicleta o motoneta",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Bicicleta que se utilice como medio de transporte",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Algún aparato o dispositivo para oír radio",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Televisor",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Computadora, laptop o tablet",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Línea telefónica fija",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Teléfono celular",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Internet",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Servicio de televisión de paga (Cable o satelital)",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Servicio de películas, música o videos de paga por Internet",
  "Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Consola de videojuegos"
)



datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = dplyr::any_of(viviendas_particulares),
      .fns = ~ (.x /`Viviendas particulares habitadas`)*100,
      .names = "{.col}%"
    )
  )


for (i in seq_along(viviendas_particulares)) {
  cat(
    "dplyr::relocate(`",
    paste0(viviendas_particulares[i], "%"),
    "`, .after = `",
    viviendas_particulares[i],
    "`) |> \n",
    sep = ""
  )
}


datos = datos |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Refrigerador%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Refrigerador`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Lavadora%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Lavadora`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Horno de microondas%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Horno de microondas`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Automóvil o camioneta%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Automóvil o camioneta`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Motocicleta o motoneta%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Motocicleta o motoneta`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Bicicleta que se utilice como medio de transporte%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Bicicleta que se utilice como medio de transporte`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Algún aparato o dispositivo para oír radio%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Algún aparato o dispositivo para oír radio`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Televisor%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Televisor`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Computadora, laptop o tablet%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Computadora, laptop o tablet`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Línea telefónica fija%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Línea telefónica fija`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Teléfono celular%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Teléfono celular`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Internet%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Internet`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Servicio de televisión de paga (Cable o satelital)%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Servicio de televisión de paga (Cable o satelital)`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Servicio de películas, música o videos de paga por Internet%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Servicio de películas, música o videos de paga por Internet`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Consola de videojuegos%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación Disponen Consola de videojuegos`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Refrigerador%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Refrigerador`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Lavadora%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Lavadora`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Horno de microondas%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Horno de microondas`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Automóvil o camioneta%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Automóvil o camioneta`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Motocicleta o motoneta%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Motocicleta o motoneta`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Bicicleta que se utilice como medio de transporte%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Bicicleta que se utilice como medio de transporte`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Algún aparato o dispositivo para oír radio%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Algún aparato o dispositivo para oír radio`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Televisor%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Televisor`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Computadora, laptop o tablet%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Computadora, laptop o tablet`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Línea telefónica fija%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Línea telefónica fija`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Teléfono celular%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Teléfono celular`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Internet%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Internet`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Servicio de televisión de paga (Cable o satelital)%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Servicio de televisión de paga (Cable o satelital)`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Servicio de películas, música o videos de paga por Internet%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Servicio de películas, música o videos de paga por Internet`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Consola de videojuegos%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No disponen Consola de videojuegos`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Refrigerador%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Refrigerador`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Lavadora%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Lavadora`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Horno de microondas%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Horno de microondas`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Automóvil o camioneta%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Automóvil o camioneta`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Motocicleta o motoneta%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Motocicleta o motoneta`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Bicicleta que se utilice como medio de transporte%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Bicicleta que se utilice como medio de transporte`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Algún aparato o dispositivo para oír radio%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Algún aparato o dispositivo para oír radio`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Televisor%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Televisor`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Computadora, laptop o tablet%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Computadora, laptop o tablet`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Línea telefónica fija%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Línea telefónica fija`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Teléfono celular%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Teléfono celular`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Internet%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Internet`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Servicio de televisión de paga (Cable o satelital)%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Servicio de televisión de paga (Cable o satelital)`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Servicio de películas, música o videos de paga por Internet%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Servicio de películas, música o videos de paga por Internet`) |> 
  dplyr::relocate(`Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Consola de videojuegos%`, .after = `Disponibilidad de bienes y tecnologías de la información y de la comunicación No especificado Consola de videojuegos`)
  
  
  
##################################
### Poblacion de 15 años y mas ###
##################################

datos = datos |> 
  dplyr::mutate(
    `Poblacion Analfabeta%` = (`Poblacion Analfabeta`/`Población de 15 años y más`)*100
  ) |> 
  dplyr::relocate(`Poblacion Analfabeta%`, .after = `Poblacion Analfabeta`)
  

#####################################################
### Población económicamente activa Ocupada Total ###
#####################################################

ocupada_total = c(
  "Población económicamente activa Ocupada Hombres",
  "Población económicamente activa Ocupada Mujeres"
)


datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = dplyr::any_of(ocupada_total),
      .fns = ~ (.x /`Población económicamente activa Ocupada Total`)*100,
      .names = "{.col}%"
    )
  )


for (i in seq_along(ocupada_total)) {
  cat(
    "dplyr::relocate(`",
    paste0(ocupada_total[i], "%"),
    "`, .after = `",
    ocupada_total[i],
    "`) |> \n",
    sep = ""
  )
}


datos = datos |> 
  dplyr::relocate(`Población económicamente activa Ocupada Hombres%`, .after = `Población económicamente activa Ocupada Hombres`) |> 
  dplyr::relocate(`Población económicamente activa Ocupada Mujeres%`, .after = `Población económicamente activa Ocupada Mujeres`) 



#####################
### Total estatal ###
#####################

datos = datos |> 
  dplyr::mutate(
    `Población total%` = (`Población total`/sum(`Población total`, na.rm = T))*100
  ) |> 
  dplyr::relocate(`Población total%`, .after = `Población total`)



############################
### Ingreso por remesas% ###
############################

datos = datos |> 
  dplyr::mutate(
    `Ingresos por remesas Enero-Septiembre(2025)%` = (`Ingresos por remesas Enero-Septiembre(2025)`/ sum(`Ingresos por remesas Enero-Septiembre(2025)`, na.rm = T))*100
  ) |> 
  dplyr::relocate(`Ingresos por remesas Enero-Septiembre(2025)%`, .after = `Ingresos por remesas Enero-Septiembre(2025)`)

datos |>  openxlsx::write.xlsx("Output/Infografia_Base_Municipal_2026_Enero.xlsx")
