rm(list=ls())
gc()
library(data.table)
library(readxl)
library(readstata13)
library(stringr)

path = 'C:/Users/Hugues/Desktop/Cours Ensae/econo'

r_6m = read_excel(paste0(path, '/retard_6eme.xls'), col_names = c('num','nom','ret_6m'), skip = 6)
r_6m = as.data.frame(r_6m)
r_6m = r_6m[!is.na(r_6m$num),]

esp_vie = read_excel(paste0(path, '/esp_vie.xls'), col_names = c('num','nom','esp_vie',1,2,3,4,5), skip = 5)
esp_vie = as.data.frame(esp_vie)[,c('num','nom','esp_vie')]
esp_vie = esp_vie[!is.na(esp_vie$num),]

taux_chom = read_excel(paste0(path, '/taux_chomage.xls'),col_names = c('nom','an1','an2','an3','an4'),skip=3)
taux_chom = as.data.frame(taux_chom)
taux_chom = taux_chom[-c(1,2,121),]
chom = rbind(as.data.frame(str_split_fixed(taux_chom$nom, "-", 2)))
taux_chom = cbind(chom, taux_chom)[,c('V1','an1','an2','an3','an4')]
taux_chom$an1 = as.integer(taux_chom$an1)
taux_chom$an2 = as.integer(taux_chom$an2)
taux_chom$an3 = as.integer(taux_chom$an3)
taux_chom$an4 = as.integer(taux_chom$an4)
taux_chom = data.frame(num=taux_chom$V1, chomage_moy=rowMeans(taux_chom[,c('an1','an2','an3','an4')]))




departement = merge(r_6m, esp_vie, by = c('num','nom'),add=F)
departement$ret_6m = round(as.numeric(departement$ret_6m), 2)
departement$esp_vie = round(as.numeric(departement$esp_vie), 2)
departement


departement = merge(departement, taux_chom, by = 'num')
departement

fwrite(departement,paste0(path,"/departements.csv"))
write.dta(departement,paste0(path,"/departements.dta"))

