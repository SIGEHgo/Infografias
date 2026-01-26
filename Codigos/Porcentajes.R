datos = "Output/Base_Sin_Operaciones_2025_Enero.xlsx" |>  readxl::read_excel()

columnas = names(datos) |>  as.data.frame()

### Pasar a numericos

datos = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = c(`Superficie (km2)`:`Número de áreas protegidas`, 
                `Cantidad promedio diaria de residuos sólidos urbanos recolectados`:`Grado promedio de escolaridad`,
                `Población de 15 años y más`:`Popoluca insuficientemente especificado`), 
      .fns = ~ .x |>  as.numeric()
    )  
  )


### Para columnas que tienen error  buscar como usartryCatch

###################
### Porcentajes ###
####################
datos$`Población total`


poblacion_total = c(
  "Población Rural",
  "Población Urbana",
  "Población Mujeres",
  "Población Hombres",
  "Población infantil (0-14 años)",
  "Población juvenil (15-29 años)",
  "Población (18 años y más)",
  "Población adulta (30-59 años)",
  "Población adulta mayor (60 y más años)",
  "Usuarios de los Servicios de Salud",
  "Se considera indígena",
  "Poblacion Analfabeta"
)




p = datos |> 
  dplyr::mutate(
    dplyr::across(
      .cols = dplyr::any_of(poblacion_total),
      .fns = ~ (.x /`Población total`)*100,
      .names = "{.col}%"
    )
  )

for (i in seq_along(poblacion_total)) {
  print(i)
}
