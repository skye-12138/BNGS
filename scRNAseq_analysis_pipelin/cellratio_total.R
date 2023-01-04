cellratio_total<-function(seurat_obj){
  a<-as.data.frame(table(Idents(seurat_obj)))
  a$ratio<-a$Freq/sum(a$Freq)
  a<-a[order(a$ratio,decreasing = T),]
  a$Var1<-factor(a$Var1,levels = a$Var1)
  levels(a$Var1)<-a$Var1
  a$sub<-"ALL"
  colnames(a)[c(1,2)]<-c("cellType","num")
  return(a)
}
