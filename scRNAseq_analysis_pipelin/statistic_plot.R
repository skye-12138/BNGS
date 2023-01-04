statistic_plot<-function(matrix,type="",usage="",condition=NULL,save=FALSE,top=10){
  if(usage == "cellratio"){
    if(type == "bar"){
      P<-ggplot(matrix) +
        aes(x = get(sample), y = Percentage, fill = cellType) +
        geom_col() +
        scale_fill_hue(direction = 1) +
        theme_minimal()+
        labs(x=sample)+
        scale_fill_manual(values = paletteer::paletteer_d("ggsci::category20_d3",n=length(unique(seurat_obj@meta.data[[celltype]]))))
      if(is.null(condition) == F){
        P<-P+facet_wrap(.~condition,scales = 'free')
      }
    }
    else if(type == "pie"){
      P<-ggplot(matrix) +
        aes(x= sub, fill = cellType, weight = num) +
        geom_bar(position = "fill") +
        scale_fill_hue() +coord_polar(theta = 'y')+
        theme_pubclean()+
        theme(axis.text.x=element_blank(),axis.title.x=element_blank(),axis.title.y = element_blank(),axis.text.y = element_blank()) +
        scale_fill_manual(values = paletteer_d("ggsci::category20_d3",n=length(unique(matrix$cellType))),labels = paste(unique(matrix$cellType),"(",scales::percent(matrix$ratio),")",sep = ""))
    }
  }
  ###can add other usage and plot script here 
}
  