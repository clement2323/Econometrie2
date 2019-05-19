rm(list=ls())
gc()
library(data.table)
library(ggplot2)
library(RColorBrewer)
#RQ il faudra faire des stats descs sur 1990 2002 aussi -> idée  ouvrir sur stata, regarder les variables pertinentes via dico et exporter la table de stata avec les variables sélectionnées..

source("C:/Users/Hugues/Desktop/Cours Ensae/econo/Codes/libelle_variable.R")
#source("C:/Users/Clement/Desktop/Projet Économétrie 2/Codes/libelle_variable.R")



df = fread('C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.csv')
df2 = fread('C:/Users/Hugues/Desktop/Cours Ensae/econo/table90_02.csv')
df3 = fread('C:/Users/Hugues/Desktop/Cours Ensae/econo/salfr.csv')
#df = fread('C:/Users/Clement/Desktop/Projet Économétrie 2/table_finale.csv')

df2$ddipl = as.integer(df2$ddipl)
df2$salfr = as.integer(df3$salfr)
df2$salfr = df2$salfr


# Pour les stats des on enleve qd on ne connait pas salaire et diplome?
# ici on garde salaire > 500!!!! Bonne idée ?
#999998 =Refus ,Ne sait pas =999999


#PROBLEME : passage du franc à l'euro => actualisation en PPA par rapport à 2013
df = df[!is.na(df$ddipl) & !is.na(df$salmee) & df$salmee >500 & !(df$salmee %in% c(9999998,9999999))]
df2 = df2[!is.na(df2$ddipl) & !is.na(df2$salfr) & df2$salfr >500 & !(df2$salfr %in% c(9999998,9999999))]

actu_eur2013<-setNames(c(1.00, 1.00, 1.01, 1.03, 1.05, 1.07, 1.07, 1.10, 1.11, 1.13, 1.15, 1.18, 1.20, 0.19, 0.19, 0.19,
                          0.19, 0.20, 0.20, 0.20, 0.21, 0.21, 0.21, 0.22, 0.22),2014:1990)
df2$actueur<-actu_eur2013[as.character(df2$annee)]
df2$sal_actu <- df2$actueur * df2$salfr

df$actueur<-actu_eur2013[as.character(df$annee)]
df$sal_actu <- df$actueur * df$salmee

df_suite = rbind(df[,c('annee','sal_actu','ddipl')], df2[,c('annee','sal_actu','ddipl')])
df_suite


par(mfrow=c(1,1))
plot(density(df_suite[df_suite$sal_actu<5000 & df_suite$annee < 2010 & df_suite$annee >= 2000,]$sal_actu,na.rm = TRUE), col = 'red')
lines(density(df_suite[df_suite$sal_actu<5000 & df_suite$annee < 2000,]$sal_actu,na.rm = TRUE))
lines(density(df_suite[df_suite$sal_actu<5000 & df_suite$annee >= 2010,]$sal_actu,na.rm = TRUE), col = 'blue')


# on passe de 400 000 à 120 000


# boxplot

#Petite explication pour Hugues : après avoir sourcé le code avec les libellé on a 
#des vecteurs nommés avec pour nom les modas codées des variables et pour valeur les libellés.
#si je veux tabler la variable dip et que je veux les libellés

#sans libelle
table(df_suite$ddipl)
#avec libelle , j'appelle le nom via le vecteur nomme dip_libelle -> dip_libelle[as.character(df$dip)]
df_suite$decennie = df_suite$annee %/% 10

par(mfrow=c(2,2))
sapply(split(df_suite,df_suite$decennie),function(df_y){
  #df_y<-df
  #paste(names(sort(freq_dip)),collapse=",")
  freq_dip<-sort(round(prop.table(table(ddipl_lib[as.character(df_y$ddipl)]))*100,2))
  plot(freq_dip, ylab = 'pourcentage', cex.axis=1.5, cex.lab = 1.5)
  title(main=paste("moyenne sur la décennie",df_y[1,]$decennie*10,sep=" "),cex.main=2)
  text(seq_along(freq_dip), 
       srt = 60, adj= 1,-300,xpd = TRUE,
       labels = names(freq_dip), cex=10)
})


df$dip<-as.character(df$dip)
#classes d'âge

df$ag_cl <- cut(df$ag, breaks = quantile(df$ag), include.lowest = TRUE)

ggplot(data = cbind(df,dip_l=dip_libelle[df$dip]))+geom_bar(position="dodge",aes(x=dip_l,fill=ag_cl))+coord_flip()+
  scale_x_discrete(
    limits=c("Autre diplôme (niveau bac+2)","DEUG","Brevet de technicien-brevet professionnel","Paramédical et social (niveau bac+2)","Maîtrise (M1)","Certificat d'études primaires","Ecoles niveau licence et au-delà","Bac professionnel"," Licence (L3)"," Bac technologique","Master (recherche ou professionnel),DEA,DESS,Doctorat","Brevet des collèges","Baccalauréat général","DUT-BTS","Sans diplôme","CAP-BEP")
   ,labels=c("Autre diplôme (niveau bac+2)","DEUG","Brevet de technicien-brevet professionnel","Paramédical et social (niveau bac+2)","Maîtrise (M1)","Certificat d'études primaires","Ecoles niveau licence et au-delà","Bac professionnel"," Licence (L3)"," Bac technologique","Master (recherche ou professionnel),DEA,DESS,Doctorat","Brevet des collèges","Baccalauréat général","DUT-BTS","Sans diplôme","CAP-BEP")
  ) +
  theme(
  legend.title=element_blank(),  
  legend.position=c(.73,.7),
  axis.title.y=element_blank(), 
  text=element_text(family="serif",size=7),
  plot.title=element_text(face="bold",hjust=c(0,0))
)+ scale_fill_brewer(palette="YlGnBu")

#Les jeunes ont tendances à être qielques peu plus diplomés..#portes ouvertes

#salmet
table(df$salmet) #Ok salmet n'est pas du tout renseignée... faire des essais sur stata pour voir si on a pas de pb avec read foreign

table(df$ag)


par(cex.axis=0.5, cex.lab=1, cex.main=1, cex.sub=1)
boxplot(salmee ~ ddipl, data = df, outline = F,xaxt = "n", 
        space=10,ylab = "salaire mensuel")
title(main=paste("salaire mensuel en fonction du diplôme","\n",sep=""),cex.main=1)
title(main=paste("\n","moyenne sur toutes les années",sep=""),cex.main=0.8)
text(seq(1,6,by=1), 
     srt = 60, adj= 1, xpd = TRUE,
     labels = ddipl_lib[-1], cex=0.65)


#


#TAFF Hugues
# 
# data = df[!is.na(df$salmee) & df$salmee != 0 & df$salmee < 999998]
# data
# summary(data)
# 
# 
# 
# 
# 
# 
# 
# # Question 3
# 
# plot(aggregate(data$salmee, by = list(as.factor(data$annee)), mean),
#      xlab = "annee",ylab="salaire moyen", main = "salaire moyen en fonction de l'annee")
# plot(aggregate(data$agedip, by = list(as.factor(data$annee)), mean),
#      xlab = "annee",ylab="nb annee d'etude moyen", main = "nb annee d'etude moyen en fonction de l'annee")
# dif_sal = aggregate(data$salmee, by = list(as.factor(data$nbaetude), as.factor(data$annee)), mean)
# dif_sal
# 
# col_pre = dif_sal[dif_sal$Group.1 == 20,]$x / dif_sal[dif_sal$Group.1 == 15,]$x
# col_pre_lic = dif_sal[dif_sal$Group.1 == 17,]$x / dif_sal[dif_sal$Group.1 == 15,]$x
# plot(x = 2003:2014, col_pre, type = 'l', ylim = c(1.1, 1.7),
#      xlab = "annee", ylab = "college premium", main = 'evolution du college premium')
# lines(x = 2003:2014, col_pre_lic, col = 'blue', type = 'l')
# 
# # personne ayant fait étude dans sup sans obtenir diplôme ?
# # en fonction age/sexe ?
# 
# 
# 
# 
# 
# # Question 4
# 
# model = lm(log(salmee) ~ nbaetude + poly(exppo, 2, raw = TRUE), data = data)
# summary(model)
# 
# 
# 
# 
# 
# 
# # Question 5
# 
# 
# 
# 
# 
# 
# 
# # Question 6
# 
# library(VGAM)
# library(MASS)
# 
# df = fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/data_pour_suite.csv")
# 
# df = df[!df$salmet %in% c("", 8, 98, 99)]
# df
# 
# # on regarde a quoi ressemble salmet
# summary(df$salmet)
# levels(as.factor(df$salmet))
# 
# # on se rend compte qu'il y a un changement au cours du temps
# # on en tient compte
# 
# df$salmet[df$salmet == "1"] <- "A"
# df$salmet[df$salmet == "2"] <- "B"
# df$salmet[df$salmet == "3"] <- "C"
# df$salmet[df$salmet == "4"] <- "D"
# df$salmet[df$salmet == "5"] <- "E"
# df$salmet[df$salmet == "6"] <- "F"
# df$salmet[df$salmet == "7"] <- "G"
# df$salmet[df$salmet == "8"] <- "H"
# df$salmet[df$salmet == "9"] <- "I"
# df$salmet[df$salmet == "10"] <- "J"
# df
# 
# # ressort les coefficients et les seuils...
# polr(as.factor(salmet) ~ nbaetude + poly(exppo, 2, raw = TRUE), data = df )
# 
# 
# 
# 
# 
# 
# # Question 7
# 
# ########################################
# ## Partie 3
# df = fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/data_pour_suite.csv")
# df





