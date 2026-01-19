library(readxl)
datos=readxl::read_excel("../../bases de datos practicas/cpv2020_b_hgo_01_poblacion.xlsx",sheet=5)

datos1= datos |> 
  dplyr::select(`INEGI. Censo de Población y Vivienda 2020. Tabulados del Cuestionario Básico`:...3)

datos1= datos1 |> dplyr::filter(!is.na(...2))
names(datos1)=datos1[1,]
datos1=datos1[-c(1,2),]

names(datos1)[3]="Poblacion Total" 

datos1= datos1 |> 
    dplyr::mutate(
      `Poblacion Total`= `Poblacion Total`|> as.numeric())


datos1= datos1 |>
  dplyr::mutate(
  `Poblacion Total%`= (`Poblacion Total`/ sum(`Poblacion Total`,na.rm=T))*100
)

class(datos1$`Poblacion Total`)

#####ya que añadimos una columna nueva, ahora tenemos que ir limpiando y añadiendo nuevas columnas 
#####ahora vamos a abrir otra base de datos para filtrar los datos sobre población
datos12=readxl::read_excel("../../bases de datos practicas/Exportar_1.xls",sheet=4)

datos12= datos12 |> 
    dplyr::select(CVEGEO,NOM_ENT,NOMGEO,POB1,POB8,POB11,POB21,POB14,POB15,POB23)


datos12= datos12 |> 
    dplyr::mutate(
      POB14=POB14 |> as.numeric()
    )

datos12= datos12 |> 
  dplyr::mutate(
    POB15=POB15 |> as.numeric()
  )


datos12=datos12 |> 
    dplyr::mutate(
      `Poblacion adulta(30-59)`= POB14+ POB15
    )
datos12= datos12 |> 
  dplyr::select(-POB14,-POB15)

datos12= datos12 |> 
  dplyr::rename(
      municipio=NOMGEO,Estado=NOM_ENT,`Población Total`=POB1,`Población Infantil(0-14 años)`=POB8,`Población Juvenil(15-29 años)`=POB11,`Población 18 años o más`=POB21,`Población 60 años o más`=POB23
  )



datos12=datos12 |> 
    dplyr::mutate(
        `Población Infantil(0-14 años)`=`Población Infantil(0-14 años)` |> as.numeric()
    )

datos12=datos12 |> 
    dplyr::mutate(
        dplyr::across(.cols = `Población Total`:`Poblacion adulta(30-59)`,.fns = ~.x |> as.numeric())
    )



datos12=datos12 |> 
    dplyr::mutate(
       `Población Infantil(0-14 años)%`= (`Población Infantil(0-14 años)`/`Población Total`)*100
    )

datos12=datos12 |> 
  dplyr::mutate(
    `Población Juvenil(15-29 años)%`= (`Población Juvenil(15-29 años)`/`Población Total`)*100
  )

datos12= datos12 |>
  dplyr::mutate(
   `Población 18 años o más%`= (`Población 18 años o más`/`Población Total`)*100,
   `Población 60 años o más%`=( `Población 60 años o más`/`Población Total`)*100,
   `Poblacion adulta(30-59)%`=(`Poblacion adulta(30-59)` /`Población Total`)*100,
   )

datos12=datos12 |> 
    dplyr::relocate(`Población Infantil(0-14 años)%`,.after = `Población Infantil(0-14 años)`) |> 
    dplyr::relocate(`Población Juvenil(15-29 años)%`,.after = `Población Juvenil(15-29 años)`) |> 
    dplyr::relocate(`Población 18 años o más%`,.after = `Población 18 años o más`) |> 
    dplyr::relocate(`Población 60 años o más%`,.after = `Población 60 años o más`) |> 
    dplyr::relocate(`Poblacion adulta(30-59)%`,.after = `Poblacion adulta(30-59)`)

datos12=datos12 |> 
  dplyr::relocate(`Poblacion adulta(30-59)`,.after = `Población 18 años o más%`) |> 
  dplyr::relocate(`Poblacion adulta(30-59)%`,.after = `Poblacion adulta(30-59)`)


datos13=readxl::read_excel("../../bases de datos practicas/Exportar2-salud.xls")


datos13= datos13 |> 
    dplyr::select(CVEGEO,SALUD1)

datos13= datos13 |> 
  dplyr::rename(`usuarios de los servicio de salud`=SALUD1)

datos13= datos13 |> 
  dplyr::mutate(
    `usuarios de los servicio de salud`= `usuarios de los servicio de salud` |>  as.numeric()
  )

datos13=datos13 |> 
  dplyr::mutate(
    `CVEGEO`= `CVEGEO` |> as.numeric()
  )

datos13= datos13 |> 
  dplyr::left_join(y=datos131,by=c("CVEGEO"="CVEGEO"))
  

####abrimos una base con poblacion total para añadirla a la otra 
datos131=readxl::read_excel("../../bases de datos practicas/Exportar_1.xls",sheet=4)

datos131= datos131 |> 
  dplyr::select(CVEGEO,POB1)


datos131= datos131 |> 
  dplyr::rename(
    `Poblacion Total`= POB1
  )
datos131=datos131 |> 
  dplyr::mutate(
    `CVEGEO`= `CVEGEO` |> as.numeric()
  )

############regresamos a nuestra base de datos 13
 

###la vamos a juntar con la base de datos de 13


datos13= datos13 |> 
    dplyr::left_join(y=datos131,by=c(CVEGEO==CVEGEO))
