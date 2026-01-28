archivos = list.files(path = "Inputs/Canva/Municipal/", full.names = T)

for (i in 1:4) {
  cat("Vamos imprimir el lote", i, "\n")
  pag = archivos[grepl(paste0("P", i, "\\.pdf$"), archivos)] 
  pdftools::pdf_combine(input = pag, output = paste0("Inputs/Canva/Municipal/Infografia_Municipal_P", i, ".pdf"))
  cat(pag, "\n")
}




#### Juntar
archivos = list.files(path = "Inputs/Canva/Municipal/", full.names = T)
archivos = archivos[!grepl("Lote", archivos)]
archivos


datos = "Output/Infografia_Base_Municipal_2026_Enero.xlsx" |>  readxl::read_excel()
datos = datos |> 
  dplyr::select(CVE_MUN, Municipio) |> 
  dplyr::mutate(
    Nombre = paste(CVE_MUN, "-", Municipio)
    ) 

for (j in seq_along(datos$Nombre)) {
  
  cat("Vamos en ", datos$Nombre[j], "\n")
  
  paginas = lapply(seq_along(archivos), FUN = function(i) {
  temporal = tempfile(fileext = ".pdf")
  pdftools::pdf_subset(
    input = archivos[i],
    pages = j,
    output = temporal
  )
  
  return(temporal)
  })
  
  pdftools::pdf_combine(
    input = paginas,
    output = paste0("Output/Infografias/Municipal/", datos$Nombre[j], ".pdf")
  )

}




