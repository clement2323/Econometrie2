rm(list=ls())
gc()
library(data.table)
library(foreign)
source("C:/Users/Hugues/Desktop/Cours Ensae/econo/Codes/libelle_variable.R")

df = fread('C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.csv')

# Pour les stats des on enleve qd on ne connait pas salaire et diplome?
# ici on garde salaire > 500!!!! Bonne idée ?
df = df[!is.na(df$ddipl) & !is.na(df$salmee) & df$salmee >500 & df$salmee < 999998]

# on passe de 400 000 à 120 000

# boxplot
par(cex.axis=0.5, cex.lab=1, cex.main=1, cex.sub=1)
boxplot(salmee ~ ddipl, data = df, outline = F,xaxt = "n", 
        space=10,ylab = "salaire mensuel")
title(main=paste("salaire mensuel en fonction du diplôme","\n",sep=""),cex.main=1)
title(main=paste("\n","moyenne sur toutes les années",sep=""),cex.main=0.8)
text(seq(1,6,by=1), 
     srt = 60, adj= 1, xpd = TRUE,-300,
     labels = ddipl_lib[-1], cex=0.65)





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
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# table(df$dip)
# # 
# # Vide Non renseigné
# # 10 Master (recherche ou professionnel), DEA, DESS, Doctorat
# # 12 Ecoles niveau licence et au-delà
# # 22 Maîtrise (M1)
# # 21 Licence (L3)
# # 30 DEUG
# # 31 DUT, BTS
# # 32 Autre diplôme (niveau bac+2)
# # 33 Paramédical et social (niveau bac+2)
# # 41 Baccalauréat général
# # 42 Bac technologique
# # 43 Bac professionnel
# # 44 Brevet de technicien, brevet professionnel
# # 50 CAP, BEP
# # 60 Brevet des collèges
# # 70 Certificat d'études primaires
# # 71 Sans diplôme