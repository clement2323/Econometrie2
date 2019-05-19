rm(list=ls())
gc()
library(data.table)
library(readxl)
library(readstata13)
library(stringr)
library(ggplot2)
library(plyr)
source("C:/Users/Hugues/Desktop/Cours Ensae/econo/Codes/libelle_variable.R")

df1 = fread('C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.csv')
df2 = fread('C:/Users/Hugues/Desktop/Cours Ensae/econo/smauto1.csv')

df1$salfr = df1$salmee
df1 = df1[,c('annee','ag','salmee', 'salfr','extri','ddipl')]
summary(df1$annee)

df = rbind(df1,df2,use.names = F)
df$salmee = as.integer(df$salmee)
df$extri = as.integer(df$extri)
df


actu_eur2013<-setNames(c(1.00, 1.00, 1.01, 1.03, 1.05, 1.07, 1.07, 1.10, 1.11, 1.13, 1.15, 1.18, 1.20, 0.19, 0.19, 0.19,
                         0.19, 0.20, 0.20, 0.20, 0.21, 0.21, 0.21, 0.22, 0.22),2014:1990)
df$actu_eur13<-actu_eur2013[as.character(df$annee)]
df
df$salaire = ifelse(df$annee <= 2001, df$salfr*df$actu_eur13, df$salmee*df$actu_eur13)
df$salaire
sum(is.na(df$salaire))
nrow(df)
df = df[!is.na(df$salaire) & !is.na(df$extri)]
a = aggregate(df$extri, by=list(df$annee), sum)

sum_extri = setNames(a$x, a$Group.1)
df$s_extri= sum_extri[as.character(df$annee)]

df$decennie = df$annee %/% 10


par(mfrow=c(1,1))
sapply(split(df,df$decennie),function(df_y){
  
val = c(1,3,4,5,6,7)
freq = 1:7
for (i in val){
  df_bis = df_y[df_y$ddipl == i]
  freq[i] = sum(df_bis$extri)
}
freq = freq[-2]
freq = setNames(freq/sum(freq)*100,ddipl_lib[2:7])
toplot = data.frame(freq, ddipl_lib[2:7])
colnames(toplot) <- c('frequence','diplome')
#freq_dip<-sort(round(prop.table(table(ddipl_lib[as.character(df_y$ddipl)]))*100,2))
#barplot(freq, ylab = 'pourcentage', names.arg = ddipl_lib[2:7], cex.axis = 1.2, cex.names = 1)
#title(main=paste("moyenne sur la décennie",df_y[1,]$decennie*10,sep=" "),cex.main=1.2)
p <- ggplot(toplot, aes(x=diplome, y=frequence)) + geom_bar(stat="identity", width=0.5, fill="steelblue")
p = p +theme(axis.text=element_text(size=10),
             axis.title=element_text(size=10,face="bold")) + ggtitle(paste("moyenne sur la décennie",df_y[1,]$decennie*10,sep=" ")) + theme(plot.title = element_text(hjust = 0.5))
plot(p)
#text(seq_along(freq), 
#    srt = 60, adj= 1,-300,xpd = TRUE,
#   labels = ddipl_lib[val], cex=10)
})

df=df[df$salaire < 100000 & !is.na(df$ddipl),]
df$diplome = as.factor(df$ddipl)
levels(df$diplome) = c("sup","Bac+2","Bac","CAP","Brevet","CEP")
p<-ggplot(df, aes(x=diplome, y=salaire, as.factor(diplome))) +
  geom_boxplot(outlier.shape = NA) + coord_cartesian(ylim = c(0, 5000) ) + ggtitle("Salaire moyen en fonction du diplôme (moyenne sur 1990-2014)") + theme(plot.title = element_text(hjust = 0.5))
p

tp = ddply(df,  .(annee, ddipl), function(x) data.frame(wret=weighted.mean(x$salaire, x$extri)))
colnames(tp) = c('année','diplôme','moyenne')
ggplot(data = tp, aes(x = année, y = moyenne, colour = diplôme))+geom_line()+ggtitle("Evolution de la moyenne pondérée des salaires") + theme(plot.title = element_text(hjust = 0.5))

summary(df$annee)
# CHANGER EN 2014 EN-DESSOUS
col_prem = data.frame(1990:2012,1990:2012,1990:2012)
colnames(col_prem) = c('année', 'college_premium','BacPlus2')
for (i in 1990:2012){
  tp_annee = tp[tp$année == i,]
  a = tp_annee[tp_annee$diplôme == 'sup',]$moyenne
  b = tp_annee[tp_annee$diplôme == 'Bac+2',]$moyenne
  c = tp_annee[tp_annee$diplôme == 'Bac',]$moyenne
  col_prem[i-1989,] = c(i,a/c,b/c)
}
col_prem
ggplot(col_prem, aes(année)) + geom_line(aes(y = college_premium, colour = "supérieur")) + geom_line(aes(y = BacPlus2, colour = "Bac+2"))+ggtitle("Evolution du college premium")+ theme(plot.title = element_text(hjust = 0.5))

