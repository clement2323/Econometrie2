rm(list=ls())
gc()
library(data.table)
library(readstata13)

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
fichier<-lapply(files[-c(1)],function(f){
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
  interet = data[ ,variable[variable %in% colnames(data)]]
  #
  })

table_finale = rbindlist(fichier, use.names = TRUE, fill = TRUE)

#test pour voir qu'on a bien 6 interrogation a peu près par indiv + création de l'identifiant de l'indiv au passage id_ind<-iden+noi

table_finale$ident_ind<-paste0(table_finale$ident,"_",table_finale$noi)
#au niveau de l'indiv on a max 2interrogation, regardons au niveau du logement (on espère avoir 6 pour 6 trimestres..)
tmp<-sapply(split(paste0(table_finale$annee,"_",table_finale$trim),table_finale$ident),length)
#ARf... à demande, on devait avoir 6 fois le logement dans la base en moyenne..

#ok je filtre sur les variables et salarié et actif occupé 
table_finale = table_finale[(table_finale$stat2 == "2" & table_finale$actop =="1") ,]


#Passage des dates et age en numérique

table_finale$annee<-as.integer(table_finale$annee)
table_finale$datdip<-as.integer(table_finale$datdip)
table_finale$datgen<-as.integer(table_finale$datgen)
table_finale$datsup<-as.integer(table_finale$datsup)
table_finale$ag<-as.integer(table_finale$ag)
table_finale$naia<-as.integer(table_finale$naia)


#nombre années études j'abandonne l'idée d'utiliser datsup dat gen datdip
#expérience potentielle = expérience pro qu'aurait eu quelqu'un si il avait travailler toute sa vie en dehors de ses années d'études et de sa prime enfance
#= âge -annéesétudes (de 6ans à...) -6  # pour annee etude on fait ça à l'arrache car  datgen et datsup donnet des valeurs aberrantes

# ("1" = 23,"3" = 20,"4" = 18,"5" = 17,"6" = 14,"7" = 14) # on va approxmer pour les études courtes, pour le sup on utilise datdip et datsup
dip_vers_annee_etude<-setNames(c(17, 14, 12, 11, 8, 8),c(1,3,4,5,6,7))
table_finale$annee_etude<-dip_vers_annee_etude[table_finale$ddipl]

# ddipl  : diplôme le + élevé obtenu
#- Diplôme non déclaré
#1 - Diplôme supérieur
#3 - Baccalauréat + 2 ans
#4 - Baccalauréat ou brevet professionnel ou autre diplôme de ce niveau
#5 - CAP, BEP ou autre diplôme de ce niveau
#6 - Brevet des collèges
#7 - Aucun diplôme ou CEP


#Expérience potentielle  = (âge - nombre d'années d'études - six) =âge-agedip
table_finale$exp_po =table_finale$ag - table_finale$annee_etude-6


#Petit retraitement de salmet, avant 2013 8 -> refus et après 8 est utilisé comme une tranche => je mets ces lignes là à 98 (comme pour 2013, 2014)
table_finale$salmet[table_finale$salmet=="8" & !(table_finale$annee %in% c("2013","2014"))]<-"98"


#J'efface ce qui ne sert plus
rm(list=ls()[ls()!="table_finale"])




#Rq à ce stade je n'ai pas filtré sur les valeurs manquantes de salaire


#Save en Rdata et en csv
fwrite(table_finale,"C:/Users/Clement/Desktop/Projet Économétrie 2/table_finale.csv")
save.image(file="C:/Users/Clement/Desktop/Projet Économétrie 2/table_finale.Rdata")

rm(list=ls())
gc()