###################################################################juntar PDF'S
install.packages("pdftools")
library(pdftools)


pdf_combine(
  input=c("Inputs/Canva/Municipal/(Lote 1) Infografia_Municipal_P1.pdf","Inputs/Canva/Municipal/(Lote 2) Infografia_Municipal_P1.pdf"),
  output="Infografia_municipal1"
    
)
pdf_combine(
  input=c("Inputs/Canva/Municipal/(Lote 1) Infografia_Municipal_P2.pdf","Inputs/Canva/Municipal/(Lote 2) Infografia_Municipal_P2.pdf"),
  output="Infografia_Municipal2"
)
pdf_combine(
  input=c("Inputs/Canva/Municipal/(Lote 1) Infografia_Municipal_P3.pdf","Inputs/Canva/Municipal/(Lote 2) Infografia_Municipal_P3.pdf"),
  output="Infografia_Municipal3"
)

pdf_combine(
  input=c("Inputs/Canva/Municipal/(Lote 1) Infografia_Municipal_P4.pdf","Inputs/Canva/Municipal/(Lote 2) Infografia_Municipal_P4.pdf"),
  output="Infografia_Municipal4"
)

#####################################################ahora vamos a unir las primeras paginas de cada pdf
PDFS=c("Output/Infografias/Municipal/Infografia_municipal1","Output/Infografias/Municipal/Infografia_Municipal2","Output/Infografias/Municipal/Infografia_Municipal3","Output/Infografias/Municipal/Infografia_Municipal4")

nombres