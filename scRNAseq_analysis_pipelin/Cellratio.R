##this function is for cellratio calculation, the cell ratio will be calculated as cell num of a celltype in a sample /sum(total cell number in a sample group)
##the condition parameter would determin whether the data.frame would have the column of condition for split view
cellratio<-function(seurat_obj,sample="patients",celltype="label",condition=NULL){
  if(is.null(condition) == T){
    cellratio<-as.data.frame(table(seurat_obj@meta.data[[sample]],seurat_obj@meta.data[[celltype]]))
    colnames(cellratio)<-c(sample,"cellType","num")
  }else{
    seurat_obj$unid<-paste(seurat_obj@meta.data[[sample]],seurat_obj@meta.data[[condition]],sep = "__")
    cellratio<-as.data.frame(table(seurat_obj$unid,seurat_obj@meta.data[[celltype]]))
    colnames(cellratio)<-c("unid","cellType","num")
    cellratio<-tidyr::separate(cellratio,unid,into= c(sample,"condition"),sep= "__")
  }
  cellratio %>% 
    group_by(get(sample)) %>%
    mutate(Percentage=round(num/sum(num)*100,2)) -> cellratio_percent
  cellratio_percent$sub<-"seurat_obj"
  return(cellratio_percent)
}
