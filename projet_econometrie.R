rm(list=ls())
gc()
library(data.table)
library(foreign)
library(readstata13)
library(dplyr)


path = "C:/Users/Hugues/Desktop/Cours Ensae/econo/nouvelles_donnees"
files = list.files(path)
variables = c("annee","trim","ag","salmee","salmet","datdip","datgen","datsup","ddipl","deparc","depeta")

##############################################
fichier = list()
i = 1
for (f in files){
  print(f)
  data = read.dta13(paste0(path,"/",f))
  print(setdiff(variables,colnames(data)))
  interet = data[,variables[variables %in% colnames(data)]]
  fichier[[i]] = interet
  i = i + 1
}

?rbindlist
fichier
table_finale = rbindlist(fichier, use.names = TRUE, fill = TRUE)
fwrite(table_finale,paste0(path,"/variables_interet.csv"))

##############################################

df = fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/variables_interet.csv")

df$salmee = as.integer(df$salmee)
df = df[!is.na(df$ddipl)]
# ~ 1 million de lignes 
df = df[!is.na(df$salmee) | (!is.na(df$salmet) & df$salmet != "")]
# ~ 160 000 lignes (aucun intérêt à garder lignes ou on a ni salaire ni tranche)
df[is.na(df$salmee)]
df

# experience potentielle :
df$datsup = as.integer(df$datsup)
df$datgen = as.integer(df$datgen)
df$annee = as.integer(df$annee)
df$ag = as.integer(df$ag)
df$datdip = as.integer(df$datdip)
# diplome :
#- Diplôme non déclaré
#1 - Diplôme supérieur
#3 - Baccalauréat + 2 ans
#4 - Baccalauréat ou brevet professionnel ou autre diplôme de ce niveau
#5 - CAP, BEP ou autre diplôme de ce niveau
#6 - Brevet des collèges
#7 - Aucun diplôme ou CEP

#dip = list("1" = 23,"3" = 20,"4" = 18,"5" = 17,"6" = 14,"7" = 14)

df$agedip = as.factor(df$ddipl)
levels(df$agedip) = c(23, 20, 18, 17, 14, 14)
df


df$datdip = ifelse(is.na(df$datdip), df$annee - df$ag + as.numeric(as.character(df$agedip)) ,df$datdip)
df



df$exppo = df$annee - df$datdip
df


df$nbaetude = as.numeric(as.character(df$agedip)) - 3
df

fwrite(df,"C:/Users/Hugues/Desktop/Cours Ensae/econo/data_pour_suite.csv")

###############################################################

df = fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/data_pour_suite.csv")
summary(df)

data = df[!is.na(df$salmee) & df$salmee != 0 & df$salmee < 999998]
data
summary(data)







# Question 3

plot(aggregate(data$salmee, by = list(as.factor(data$annee)), mean),
     xlab = "annee",ylab="salaire moyen", main = "salaire moyen en fonction de l'annee")
plot(aggregate(data$agedip, by = list(as.factor(data$annee)), mean),
     xlab = "annee",ylab="nb annee d'etude moyen", main = "nb annee d'etude moyen en fonction de l'annee")
dif_sal = aggregate(data$salmee, by = list(as.factor(data$nbaetude), as.factor(data$annee)), mean)
dif_sal

col_pre = dif_sal[dif_sal$Group.1 == 20,]$x / dif_sal[dif_sal$Group.1 == 15,]$x
col_pre_lic = dif_sal[dif_sal$Group.1 == 17,]$x / dif_sal[dif_sal$Group.1 == 15,]$x
plot(x = 2003:2014, col_pre, type = 'l', ylim = c(1.1, 1.7),
     xlab = "annee", ylab = "college premium", main = 'evolution du college premium')
lines(x = 2003:2014, col_pre_lic, col = 'blue', type = 'l')

# personne ayant fait étude dans sup sans obtenir diplôme ?
# en fonction age/sexe ?





# Question 4

model = lm(log(salmee) ~ nbaetude + poly(exppo, 2, raw = TRUE), data = data)
summary(model)






# Question 5







# Question 6

library(VGAM)
library(MASS)

df = fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/data_pour_suite.csv")

df = df[!df$salmet %in% c("", 8, 98, 99)]
df

# on regarde a quoi ressemble salmet
summary(df$salmet)
levels(as.factor(df$salmet))

# on se rend compte qu'il y a un changement au cours du temps
# on en tient compte

df$salmet[df$salmet == "1"] <- "A"
df$salmet[df$salmet == "2"] <- "B"
df$salmet[df$salmet == "3"] <- "C"
df$salmet[df$salmet == "4"] <- "D"
df$salmet[df$salmet == "5"] <- "E"
df$salmet[df$salmet == "6"] <- "F"
df$salmet[df$salmet == "7"] <- "G"
df$salmet[df$salmet == "8"] <- "H"
df$salmet[df$salmet == "9"] <- "I"
df$salmet[df$salmet == "10"] <- "J"
df

# ressort les coefficients et les seuils...
polr(as.factor(salmet) ~ nbaetude + poly(exppo, 2, raw = TRUE), data = df )






# Question 7

########################################
## Partie 3
df = fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/data_pour_suite.csv")
df









