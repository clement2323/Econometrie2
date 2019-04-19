rm(list=ls())
gc()
library(data.table)
# library(foreign)
 library(readstata13)
# library(dplyr)



#########################################
####Liste des des variables par thème####
#########################################
 

####champ de l'étude#### L'individu est délimité par ident noi
# 
# act #activité au sens du bit# actif occupe 1 oui 2 non
# stat2 # statut de travail, saarie non slari, ce sont les salariés qui  nous intéressent
# stc #statu de la profession principale 1  son compte ou salarié chef d'entp, salarié(autre que ch d'entp) 3 taf pour sa famille
# actop# 1 oui non
# ident #identifiant anoymisé du logement
# noi # numéro individuel
# noech #numéro de l'échantillon
# noicon #numéro individuel du conjoint
# annee # annee de l'enquete
# trim # trimestre de l'enquete
# 
# 
# ####type de travail####
# 
# contrat #type de contrat de travail CDI CDD
# ancentr #(et ancentr4) ancienneté de l'entreprise en mois
# art #travail dans le milieu artistique  ?
# dchant#durée du chomage précédent l'emploi (peut expliquer unsaliaire faible si élevé)
# dudet #durée du contrat de travail (joue sur le salaire ?)
# efen# effectif de l'entreprise
# efet # effectif de l'établissement
# naf # activité économique de l'emploi occupé
# titc#type de fonctionnaire  eleve, titulaire ou contractuel
# 
# 
# ####Socio démographie####
# ag # age detaié année révolu
# typmen #type de ménage
# typmen15 #idem 15 positions
# nbactoc # nombre actifs occupés dans le logement
# nbagenf # nombre et age des enfants
# nat28 #nationalite
# naia #année de naissance
# naim # mois de naissance
# cohab # vie en couple ?
# matri # statut matrimonial légal
# cse #CSP des actifs
# csei #idem non détaillé 
# cspp #csp pere
# cspm #csp mere
# csptot # csp(pas forcément pour les actifs)
# sexe # sexe
# scj# sexe du conjoint
# so # statut d'occupation du logement
# 
# ###Localisation
# depeta #  ?
# deparc #code département de l'établissem
# reg #région de résidence
# 
# 
# ####Salaire####
# prim #complément de primes dans le salaire
# revent #tranche de revenu annuel
# salmee # salaire déclaré de l'emploi principal
# salmet #tranche de salaire déclaré de l'emploi principal
# salred # salaire mensuel et redressé des non réponses
# 
# 
# ####Horaires et temps de travail####
# 
# sousempl#situation de sous emploi sans obj si ts complet ou inactif
# nbheur#nombre d'heures correspondant au salaire déclaré
# nbhp #nombre d'heures normalement prévues par semaines
# hhc#nombre moyen d'heures par semaine dans l'emploi principal
# hhc6#idem 6 postes
# empnh # nb d'h"ueres sup
# emphre #nb d'heures sup rémunérées
# jourtr #nombre moyen de jours travaillés pendant la semaine
# tpp #temps de travail dans l'emploi principal, 1 temps complet 2 temps partiel
# 
# 
# ####Diplome####
# spe # specialite du diplome le plus élevé
# nivet# niveau d'étude le pus élevé
# ngen #niveau d'étude le plus élevé
# cite97 # niveau d'éducation le plus élevé != diplome
# datdip #n'existe pas en 2003
# datgen # date du diplome dans l'enseignement généal et secondaire
# datsup # date diplome dans l'enseignement supérierur
# ddipl#diplome le plus élevé obtenu en 7 postes
# dip # idem 16 postes
# dip11 # idem 11 postes
# formoi # mois de fin des études initiales
# fordat # année de fin des études initiales
# forsg #spécialité suivie dans l'ennseignement secondaire


####On commence
###on charge les bases, on filtre sur les colonnes et les lignes

#ordonnées par thèmes et ordre alphaetique dans haque thèmes
variable<-c("actop","annee","ident","noi","noicon","stat2","stc","trim",
            "ancentr","art","contra","dchant","dudet","efen","efet","naf","titc","trefen","trefet",
            "ag","cohab","cse","csei","cspm","cspp","cstot","matri","naia","naim","nat14","nat28","nbactoc","nbageenfa","nbagenf","scj","sexe","so","typmen5","typmen7","typmen21","typmen15",
            "deparc","depeta","reg",
            "prim","revent","salmee","salmet","salred",
            "emphre","emphnh","hhc","hhc6","jourtr","nbheur","nbhp","sousempl","tpp",
            "cite97","datdip","datgen","datsup","ddipl","dip","dip11","fordat","formoi","forsg","ngen","nivet","spe")


path = "C:/Users/Clement/Desktop/Projet Économétrie 2/Données"
files = list.files(path)
# variables = c("annee","trim","ag","salmee","salmet","datdip","datgen","datsup","ddipl","deparc","depeta")


#Pour l'instant jej dégage la grosse table des vieilles années trop lourdes.
fichier<-lapply(files[-1],function(f){
  #f<-files[length(files)]
  data = read.dta13(paste0(path,"/",f))
  dif<-setdiff(variable,colnames(data))
  print(dif)
  #equivalences de noms si 2013 et 2014
  if(f %in% c("individu 2013.dta","individu 2014.dta")){
    tmp<-colnames(data)
    tmp[tmp=="dchantj"]<-"dchant" 
    tmp[tmp=="coured"]<-"cohab"
    colnames(data)<-tmp
    }
  
  
  #ok je filtre sur les variables et salarié et actif occupé 
  interet = data[(data$stat2 == "2" & data$actop =="1") ,variable[variable %in% colnames(data)]]
  
  })


table_finale = rbindlist(fichier, use.names = TRUE, fill = TRUE)
fwrite(table_finale,paste0(path,"/variables_interet.csv"))
rm(files,path,variable,fichier)

save.image(file=paste0(path,"/table_finale.Rdata"))

##############################################

df = fread("C:/Users/Clement/Desktop/Projet Économétrie 2/Données/variables_interet.csv")

# sum(is.na(df$ddipl)) #213 valeurs manquantes, on les enlève ?
df = df[!is.na(df$ddipl)]
# ~ 440 000 lignes
summary(df$salmee)
summary(df$salred)


sum(!is.na(df$salmee) | (!is.na(df$salmet) & df$salmet != ""))
df = df[!is.na(df$salmee) | (!is.na(df$salmet) & df$salmet != "")]
# ~ 160 000 lignes (aucun intérêt à garder lignes ou on a ni salaire ni tranche)
#Ok mais peut-on étudier la non réponse et est-elle liée au salaire justement ? => modèle de censure  =( durr...)

df[is.na(df$salmee)]
df

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









