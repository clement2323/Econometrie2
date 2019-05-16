rm(list=ls())
gc()
library(data.table)
library(readstata13)

table_finale = fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.csv")
table_finale = table_finale[!is.na(table_finale$ddipl)]
table_finale$naf4 = ifelse(table_finale$annee <= 2008, table_finale$nafg4, ifelse(table_finale$annee<= 2012, table_finale$nafg4n, table_finale$nafg004n))

cle<-paste0(table_finale$dep,table_finale$annee)

dfterti <- table_finale[table_finale$naf4 == "EV",]
cle_terti<-paste0(dfterti$dep,dfterti$annee) 
depannee_vers_tertiaire <- sapply(split(dfterti$extri,cle_terti),sum,na.rm =TRUE)
table_finale$dep_annee_terti = depannee_vers_tertiaire[cle]
table_finale$taux_tertiaire = table_finale$dep_annee_terti / (table_finale$pop_dep_annee - table_finale$pop_chomeur_dep_annee) * 100
table_finale$tx_pop_tertiaire = (table_finale$dep_annee_terti / table_finale$pop_dep_annee) * 100

dfindus <- table_finale[table_finale$naf4 == "ET",]
cleindus = paste0(dfindus$dep,dfindus$annee) 
depannee_vers_industrie <- sapply(split(dfindus$extri,cleindus),sum,na.rm =TRUE)
table_finale$dep_annee_indu = depannee_vers_industrie[cle]
table_finale$taux_indus = table_finale$dep_annee_indu / (table_finale$pop_dep_annee - table_finale$pop_chomeur_dep_annee) * 100
table_finale$tx_pop_indus = table_finale$dep_annee_indu / table_finale$pop_dep_annee * 100

table_finale$tx_chomage = (table_finale$pop_chomeur_dep_annee / table_finale$pop_dep_annee) * 100

#fwrite(table_finale,"C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.csv")
