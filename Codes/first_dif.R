rm(list=ls())
gc()
library(data.table)
library(readstata13)

df = fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.csv")
df = df[!is.na(df$ddipl) & !is.na(df$salmee) & !(df$salmee %in% c(9999998,9999999))]

#################################################
## On s'occupe ici de faire premières différences
## on fera pas diff premières sur experience ni sur diplome
## car on obtiendra des constantes
## il restera donc que le salaire et les diplomes par departement
## ------> d'ou le fait de prendre création d'établissements pour
## instrumentaliser l'augmentation du taux de diplômés (?)

df_final = list()
df[df$nbheur < 40]$nbheur <- 40
df$nbheur = ifelse(df$nbheur > 250 | is.na(df$nbheur), 150, df$nbheur)
df$salhor = df$salmee / df$nbheur

df$logsalmee = log(df$salmee)
df$logsalhor = log(df$salhor)

for (i in 2003:2013){
  dfbis = df[df$annee >=i & df$annee <= (i+1),]
  
  # on recupere les individus presents 2 années de suite
  df_ind = aggregate(dfbis$annee, by = dfbis[,c('ident_ind')], length)
  ind = df_ind[df_ind$x == 2,]$ident_ind
  
  #on fait les diff
  dif = df[df$annee == (i+1) & df$ident_ind %in% ind, c('logsalmee','logsalhor','taux_dip_dep') ] - df[df$annee == i & df$ident_ind %in% ind, c('logsalmee','logsalhor','taux_dip_dep') ]
  dif$annee = i - 2002
  dif$crea_etab = df[df$annee == (i+1)& df$ident_ind %in% ind,]$crea_etab
  dif$sexe = df[df$annee == (i+1)& df$ident_ind %in% ind,]$sexe
  dif$sit_ind = df[df$annee == (i+1)& df$ident_ind %in% ind,]$sit_ind
  dif$typmen = df[df$annee == (i+1)& df$ident_ind %in% ind,]$typmen
  dif$immigre = df[df$annee == (i+1)& df$ident_ind %in% ind,]$immigre
  dif$cspp = df[df$annee == (i+1)& df$ident_ind %in% ind,]$cspp
  df_final[[i - 2002]] = dif
}

df_final = rbindlist(df_final)

fwrite(df_final, "C:/Users/Hugues/Desktop/Cours Ensae/econo/first_dif.csv")

