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
df2 = fread('C:/Users/Hugues/Desktop/Cours Ensae/econo/table1990_2002.csv')



# ==================================
# Traitement de la base 1990-2002:
# On ne garde que les catégories suivantes : master et plus, 
# licence/maîtrise, Bac+2, Bac, diplome pro et sans diplome
dip_nomme<-setNames(c("master et plus","master et plus",
                      "licence maîtrise",
                      "licence maîtrise","Bac+2","Bac+2",
                      "Bac+2","Bac","Bac","Bac",
                      "diplôme pro","diplôme pro","diplôme pro","sans diplôme","sans diplôme","sans diplôme")
                    ,c(10,11,30,31,32,33,40,41,42,43,44,50,51,60,70,71))
sum(is.na(df2$dipl)) == sum(is.na(df2$ddipl))
df2 = df2[!is.na(df2$dipl),]
df2$sit_ind = as.factor(df2$dipl)
levels(df2$sit_ind)
levels(df2$sit_ind) = dip_nomme[levels(df2$sit_ind)]
levels(df2$sit_ind)
df2$sit_ind = as.character(df2$sit_ind)
df2 = df2[,-c('dipl')]

# =================================================
# Concaténation des bases :

colnames(df2)
df1$salfr = df1$salmee
df1 = df1[,c('annee','ag','salmee', 'salfr','extri','ddipl','sit_ind')]
colnames(df1)


df = rbind(df1,df2,use.names = F)
df$salmee = as.integer(df$salmee)
df$extri = as.integer(df$extri)

# Transformation en PPA
actu_eur2013<-setNames(c(1.00, 1.00, 1.01, 1.03, 1.05, 1.07, 1.07, 1.10, 1.11, 1.13, 1.15, 1.18, 1.20, 0.19, 0.19, 0.19,
                         0.19, 0.20, 0.20, 0.20, 0.21, 0.21, 0.21, 0.22, 0.22),2014:1990)
df$actu_eur13<-actu_eur2013[as.character(df$annee)]
df$salaire = ifelse(df$annee <= 2001, df$salfr*df$actu_eur13, df$salmee*df$actu_eur13)
df

# Suppression des NA
sum(is.na(df$salaire))/nrow(df) #bcp de lignes NA du fait de la première table
df = df[!is.na(df$salaire) & !is.na(df$extri)]
df = df[df$salaire < 100000 & !is.na(df$ddipl),]




# ===============================
# Premières stats desc avec DDIPL

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

p <- ggplot(toplot, aes(x=diplome, y=frequence)) + geom_bar(stat="identity", width=0.5, fill="steelblue")
p = p +theme(axis.text=element_text(size=10),
             axis.title=element_text(size=10,face="bold")) + ggtitle(paste("moyenne sur la décennie",df_y[1,]$decennie*10,sep=" ")) + theme(plot.title = element_text(hjust = 0.5))
plot(p)
})

# Toujours avec DDIPL

df$diplome = as.factor(df$ddipl)
levels(df$diplome) = c("sup","Bac+2","Bac","CAP","Brevet","CEP")
p<-ggplot(df, aes(x=diplome, y=salaire, as.factor(diplome))) +
  geom_boxplot(outlier.shape = NA) + coord_cartesian(ylim = c(0, 5000) ) + ggtitle("Salaire moyen en fonction du diplôme (moyenne sur 1990-2014)") + theme(plot.title = element_text(hjust = 0.5))
p

# ===========================================
# On utilise sit_ind pour la différenciation entre diplôme et étude


tp = ddply(df,  .(annee, sit_ind), function(x) data.frame(wret=weighted.mean(x$salaire, x$extri)))
colnames(tp) = c('année','diplôme','moyenne')
tp
ggplot(data = tp, aes(x = année, y = moyenne, colour = diplôme))+geom_line()+ggtitle("Evolution de la moyenne pondérée des salaires") + theme(plot.title = element_text(hjust = 0.5))


col_prem = data.frame(1990:2014,1990:2014,1990:2014,1990:2014)
colnames(col_prem) = c('année', 'college_premium','licence','BacPlus2')
for (i in 1990:2014){
  tp_annee = tp[tp$année == i,]
  a = tp_annee[tp_annee$diplôme == 'master et plus',]$moyenne
  b = tp_annee[tp_annee$diplôme == 'licence maîtrise',]$moyenne
  c = tp_annee[tp_annee$diplôme == 'Bac+2',]$moyenne
  d = tp_annee[tp_annee$diplôme == 'Bac',]$moyenne
  col_prem[i-1989,] = c(i,a/d,b/d,c/d)
}
col_prem
ggplot(col_prem, aes(année)) + geom_line(aes(y = college_premium, colour = "supérieur")) + geom_line(aes(y = licence, colour = "Licence maîtrise")) +
  geom_line(aes(y = BacPlus2, colour = "Bac+2")) + ggtitle("Evolution du college premium")+ theme(plot.title = element_text(hjust = 0.5))

