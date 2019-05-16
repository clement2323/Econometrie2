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

for (i in 2003:2013){
  dfbis = df[df$annee >=i & df$annee <= (i+1),]
  
  # on recupere les individus presents 2 années de suite
  df_ind = aggregate(dfbis$annee, by = dfbis[,c('ident_ind')], length)
  ind = df_ind[df_ind$x == 2,]$ident_ind
  
  #on fait les diff
  dif = df[df$annee == (i+1) & df$ident_ind %in% ind, c('log_salmee','taux_dip_dep','taux_tertiaire','pop_chomeur_dep_annee','tx_chomage','tx_pop_tertiaire','tx_pop_indus') ] - df[df$annee == i & df$ident_ind %in% ind, c('log_salmee','taux_dip_dep','taux_tertiaire','pop_chomeur_dep_annee','tx_chomage','tx_pop_tertiaire','tx_pop_indus') ]
  dif$annee = i
  dif$crea_etab = df[df$annee == (i+1)& df$ident_ind %in% ind,]$crea_etab
  dif$sexe = df[df$annee == (i+1)& df$ident_ind %in% ind,]$sexe
  dif$sit_ind = df[df$annee == (i+1)& df$ident_ind %in% ind,]$sit_ind
  dif$typmen = df[df$annee == (i+1)& df$ident_ind %in% ind,]$typmen
  dif$immigre = df[df$annee == (i+1)& df$ident_ind %in% ind,]$immigre
  dif$cspp = df[df$annee == (i+1)& df$ident_ind %in% ind,]$cspp
  dif$logsalmee_tplus1 = df[df$annee == (i+1)& df$ident_ind %in% ind,]$logsalmee
  dif$annee_etude_tplus1 = df[df$annee == (i+1)& df$ident_ind %in% ind,]$annee_etude
  dif$exp_po_tplus1 = df[df$annee == (i+1)& df$ident_ind %in% ind,]$exp_po
  dif$taux_dip_dep_tplus1 = df[df$annee == (i+1)& df$ident_ind %in% ind,]$taux_dip_dep
  dif$deparc = df[df$annee == (i+1)& df$ident_ind %in% ind,]$deparc
  dif$annee_deparc = paste0(dif$annee,'_',dif$deparc)
  
  if (i>=2004){
    dif$taux_dip_dep_t = df[df$annee == i& df$ident_ind %in% ind,]$taux_dip_dep
  }else{dif$taux_dip_dep_t <- as.numeric(0)}
  
  df_final[[i - 2002]] <- dif
}

df_final = rbindlist(df_final)

df_final$taux_dip_dep_tmoins1

# on a également besoin du nombre d'établissement créés les 5 dernières années,
# les 10 dernières années, il y a entre 5 et 10 ans, il y a 5 ans.
# Ce sont des instruments potentiels de la variation du taux de diplômés du supérieur.

etab<-fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/Etablissements d'enseignement superieur.csv")
etab$dep<-substr(etab$`Code département`,3,4)

#création établissement 10 années précédentes : 
df_final$crea_10dernieres <- -1
class(df_final$crea_10dernieres)
for (date in 2003:2014){
  u = etab[etab$Date %in% (date-10):date,]
  a = aggregate(u$Date, by = u[,c('dep')], length)
  a$annee = date
  a$annee_deparc = paste0(a$annee,"_",a$dep)
  etab10 = setNames(a$x, a$annee_deparc)
  class(etab10[df_final$annee_deparc])
  df_final[df_final$annee == date,]$crea_10dernieres = as.numeric(etab10[df_final[df_final$annee == date,]$annee_deparc])
}

df_final[is.na(df_final$crea_10dernieres),]$crea_10dernieres <- 0
summary(df_final$crea_10dernieres)

   
# les 5 dernières années
df_final$crea_5dernieres <- -1
class(df_final$crea_5dernieres)
for (date in 2003:2014){
  u = etab[etab$Date %in% (date-5):date,]
  a = aggregate(u$Date, by = u[,c('dep')], length)
  a$annee = date
  a$annee_deparc = paste0(a$annee,"_",a$dep)
  etab10 = setNames(a$x, a$annee_deparc)
  class(etab10[df_final$annee_deparc])
  df_final[df_final$annee == date,]$crea_5dernieres = as.numeric(etab10[df_final[df_final$annee == date,]$annee_deparc])
}

df_final[is.na(df_final$crea_5dernieres),]$crea_5dernieres <- 0
summary(df_final$crea_5dernieres)

# entre 10 et 5 ans avant
df_final$crea_5_10dernieres <- -1
class(df_final$crea_5_10dernieres)
for (date in 2003:2014){
  u = etab[etab$Date %in% (date-10):(date-5),]
  a = aggregate(u$Date, by = u[,c('dep')], length)
  a$annee = date
  a$annee_deparc = paste0(a$annee,"_",a$dep)
  etab10 = setNames(a$x, a$annee_deparc)
  class(etab10[df_final$annee_deparc])
  df_final[df_final$annee == date,]$crea_5_10dernieres = as.numeric(etab10[df_final[df_final$annee == date,]$annee_deparc])
}

df_final[is.na(df_final$crea_5_10dernieres),]$crea_5_10dernieres <- 0
summary(df_final$crea_5_10dernieres)

#entre 4 et 6 ans avant
df_final$crea_4_6dernieres <- -1
class(df_final$crea_4_6dernieres)
for (date in 2003:2014){
  u = etab[etab$Date %in% (date-6):(date-4),]
  a = aggregate(u$Date, by = u[,c('dep')], length)
  a$annee = date
  a$annee_deparc = paste0(a$annee,"_",a$dep)
  etab10 = setNames(a$x, a$annee_deparc)
  class(etab10[df_final$annee_deparc])
  df_final[df_final$annee == date,]$crea_4_6dernieres = as.numeric(etab10[df_final[df_final$annee == date,]$annee_deparc])
}

df_final[is.na(df_final$crea_4_6dernieres),]$crea_4_6dernieres <- 0
summary(df_final$crea_4_6dernieres)

names(df_final) [1] <- "dif_logsalmee"
names(df_final) [2] <- "dif_taux_dip_dep"
names(df_final) [3] <- "dif_taux_tertiaire"
names(df_final) [4] <- "dif_pop_chom"
names(df_final) [5] <- "dif_tx_chom"
names(df_final) [6] <- "dif_tx_pop_tertiaire"
names(df_final) [7] <- "dif_tx_pop_indus"

names(df_final)

fwrite(df_final, "C:/Users/Hugues/Desktop/Cours Ensae/econo/first_dif.csv")
