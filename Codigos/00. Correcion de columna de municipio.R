mun = "../../Importantes_documentos_usar/Municipios/municipiosjair.shp" |>  sf::read_sf() |>  sf::st_drop_geometry()

mun = mun |> 
  dplyr::select(
    CVEGEO, NOM_MUN
  ) |> 
  dplyr::rename(
    CVE_MUN = CVEGEO
  )



###############
### 2.Salud ###
###############

salud = "Output/Drive/2. Salud.xlsx" |>  readxl::read_excel()

salud = salud |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::select(-Municipio) 

salud |>  openxlsx::write.xlsx("Output/Drive/2. Salud.xlsx")



##################
### 3.Vivienda ###
##################

vivienda = "Output/Drive/3. Vivienda.xlsx" |>  readxl::read_excel()

vivienda = vivienda |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::select(-Municipio) 

vivienda |>  openxlsx::write.xlsx("Output/Drive/3. Vivienda.xlsx")


###################
### 4.Carencias ###
###################

carencias = "Output/Drive/4. Carencias.xlsx" |>  readxl::read_excel()

carencias = carencias |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::select(-Municipio) 

carencias |>  openxlsx::write.xlsx("Output/Drive/4. Carencias.xlsx")

##################
### 5. Pobreza ###
##################

pobreza = "Output/Drive/5. Pobreza.xlsx" |> readxl::read_excel()

pobreza = pobreza |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::select(-Municipio) 

pobreza |> openxlsx::write.xlsx("Output/Drive/5. Pobreza.xlsx")

####################
### 6. Seguridad ###
####################

seguridad = "Output/Drive/6. Seguridad.xlsx" |> readxl::read_excel()
seguridad = seguridad |> 
  dplyr::select(-Municipio)

seguridad |>  openxlsx::write.xlsx("Output/Drive/6. Seguridad.xlsx")


#########################################
### 7. Procedimientos Administrativos ###
#########################################

procedimientos = "Output/Drive/7. Procedimientos Administrativos.xlsx" |>  readxl::read_excel()
procedimientos = procedimientos |> 
  dplyr::select(-Municipio)

procedimientos |>  openxlsx::write.xlsx("Output/Drive/7. Procedimientos Administrativos.xlsx")

###################
### 8. Justicia ###
###################

justicia = "Output/Drive/8. Justicia.xlsx" |>  readxl::read_excel()
justicia = justicia |> 
  dplyr::select(-Municipio)

justicia |>  openxlsx::write.xlsx("Output/Drive/8. Justicia.xlsx")

###############################
### 9. Incidencia Delictiva ###
###############################

delictiva = "Output/Drive/9. Incidencia delictiva.xlsx" |>  readxl::read_excel()

delictiva = delictiva |> 
  dplyr::select(-Municipio) |> 
  dplyr::rename(CVE_MUN = `Cve. Municipio`) |> 
  dplyr::mutate(
    CVE_MUN = CVE_MUN |>  as.character()
  )

delictiva |>  openxlsx::write.xlsx("Output/Drive/9. Incidencia delictiva.xlsx")

###########################################
### 10. Tratamiento de Aguas Residuales ###
###########################################

residual = "Output/Drive/10. Tratamiento de Aguas Residuales.xlsx" |>  readxl::read_excel()

residual = residual |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::select(-Municipio)

all(!(residual$CVE_MUN |>  is.na()))

residual = residual |> 
  dplyr::filter(!is.na(CVE_MUN))


residual |>  openxlsx::write.xlsx("Output/Drive/10. Tratamiento de Aguas Residuales.xlsx")


#########################
### 11. Red Carretera ###
#########################

carretera = "Output/Drive/11. Red Carretera.xlsx" |>  readxl::read_excel()

carretera = carretera |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::select(-Municipio) 

carretera |>  openxlsx::write.xlsx("Output/Drive/11. Red Carretera.xlsx")

############################
### 12. Areas protegidas ###
############################

protegidas = "Output/Drive/12. Areas Protegidas.xlsx" |>  readxl::read_excel()

protegidas = protegidas |> 
  dplyr::select(-Municipio)

protegidas |>  openxlsx::write.xlsx("Output/Drive/12. Areas Protegidas.xlsx")


##########################
### 13. Medio Ambiente ###
##########################

ambiente = "Output/Drive/13. Medio Ambiente.xlsx" |>  readxl::read_excel()

ambiente = ambiente |> 
  dplyr::select(-`Municipio/ Demarcación territorial`)


ambiente |>  openxlsx::write.xlsx("Output/Drive/13. Medio Ambiente.xlsx")
#####################
### 14. Movilidad ###
#####################

movilidad = "Output/Drive/14. Movilidad.xlsx" |>  readxl::read_excel()

movilidad = movilidad |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::select(-Municipio)


movilidad |>  openxlsx::write.xlsx("Output/Drive/14. Movilidad.xlsx")

#####################
### 15. Educacion ###
#####################

educacion = "Output/Drive/15. Educacion.xlsx" |>  readxl::read_excel()

educacion = educacion |> 
  dplyr::select(-Municipio)

educacion |>  openxlsx::write.xlsx("Output/Drive/15. Educacion.xlsx")
####################
### 16. Comercio ###
####################

comercio = "Output/Drive/16. Comercio.xlsx" |>  readxl::read_excel()

comercio = comercio |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::select(-Municipio)

comercio |>  openxlsx::write.xlsx("Output/Drive/16. Comercio.xlsx")

####################
### 17. Economia ###
####################

economia = "Output/Drive/17. Economia.xlsx" |>  readxl::read_excel()

economia = economia |> 
  dplyr::select(-Municipio)

economia |>  openxlsx::write.xlsx("Output/Drive/17. Economia.xlsx")


###################
### 18. Turismo ###
###################

turismo = "Output/Drive/18. Turismo.xlsx" |>  readxl::read_excel()

turismo = turismo |> 
  dplyr::select(-Municipio)

turismo = turismo |> 
  dplyr::rename(CVE_MUN= CVEGEO)

turismo |>  openxlsx::write.xlsx("Output/Drive/18. Turismo.xlsx") 


###################
### 19. Cultura ###
###################

cultura = "Output/Drive/19. Cultura.xlsx" |>  readxl::read_excel()
cultura = cultura |> 
  dplyr::left_join(y = mun, by = c("Municipio" = "NOM_MUN")) |> 
  dplyr::relocate(CVE_MUN, .before = Municipio) |> 
  dplyr::select(-Municipio)

cultura |>  openxlsx::write.xlsx("Output/Drive/19. Cultura.xlsx")

###############################
### 20. Produccion Ganadera ###
###############################

ganadera = "Output/Drive/20. Produccion Ganadera.xlsx" |>  readxl::read_excel()

ganadera = ganadera |> 
  dplyr::select(-Municipio)

ganadera |>  openxlsx::write.xlsx("Output/Drive/20. Produccion Ganadera.xlsx")

#############################
### 21. Lenguas Indigenas ###
#############################

indigenas = "Output/Drive/21. Lengua Indigena.xlsx" |>  readxl::read_excel()

indigenas = indigenas |> 
  dplyr::mutate(
    CVE_MUN = paste0("13",CVE_MUN) |>  stringr::str_squish()
  ) |> 
  dplyr::select(-Municipio)

indigenas |>  openxlsx::write.xlsx("Output/Drive/21. Lengua Indigena.xlsx")
