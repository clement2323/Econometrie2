rm(list=ls())
gc()
library(data.table)
library(readstata13)

#je source les libellés de variables
source("C:/Users/Clement/Desktop/Projet Économétrie 2/Codes/libelle_variable.R")
#source("C:/Users/Hugues/Desktop/Cours Ensae/econo/Codes/libelle_variable.R")
#########################################
####Liste des des variables par thème####
#########################################
 
#=======================================
#Je rajoute : 
# - actualisation en euro 2013 (du coup faut tout relancer pour salmet)
# - taux chomage, retard 6eme (nb eleves avec 1 an retard en 6eme) et esp vie
#   des departements (j'avais pas vu que tu avais deja mis le chomage aha)
#departements = fread('C:/Users/Hugues/Desktop/Cours Ensae/econo/Codes/departements.csv')
departements = fread('C:/Users/Clement/Desktop/Projet Économétrie 2/Codes/departements.csv')




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
variable<-c("extri","extri15","actop","annee","ident","noi","noicon","stat2","stc","trim",
            "ancentr","art","contra","dchant","dudet","efen","efet","naf","titc","trefen","trefet",
            "ag","cohab","cse","csei","cser","cspm","cspp","cstot","matri","naia","naim","nat14","nat28","nbactoc","nbageenfa","nbagenf","scj","sexe","so","typmen5","typmen7","typmen21","typmen15",
            "deparc","depeta","reg","dep","edep","ancchomm","cstotr","associ","nafg021n","nafg021un","peun",
            "prim","revent","salmee","salmet","salred","congj","congjr","cstotcj","cstotprmcj","nafg004n","nafg4","nafg4n",
            "emphre","emphnh","hhc","hhc6","jourtr","nbheur","nbhp","sousempl","tpp","naf","naf1993","naf2003","NAFG88UN",
            "cite97","datdip","datgen","datsup","ddipl","dip","dip11","dipdet","fordat","formoi","forsg","ngen","nivet","spe")


path = "C:/Users/Clement/Desktop/Projet Économétrie 2/Données"
#path = "C:/Users/Hugues/Desktop/Cours Ensae/econo/nouvelles_donnees"
files = list.files(path)


# Concaténation des bases 

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
    tmp[tmp=="depeta"]<-"deparc" #fusion des variables département
    tmp[tmp=="nbageenfa"]<-"nbagenf"
    tmp[tmp=="extri15"]<-"extri" #j'appelle les poids de la meme facon
    colnames(data)<-tmp
    }
  interet = data[ ,variable[variable %in% colnames(data)]]
  #
  })


table_finale = rbindlist(fichier, use.names = TRUE, fill = TRUE)

#Création de l'ident individu
table_finale$ident_ind<-paste0(table_finale$ident,"_",table_finale$noi)
#library(data.table)
# fwrite(table_finale,"C:/Users/Clement/Desktop/Projet Économétrie 2/table_finale_1.csv")
 # table_finale<-fread("C:/Users/Clement/Desktop/Projet Économétrie 2/table_finale_1.csv")
##################################################
## Création des variables au niveau départemental#
##################################################
#Filtre sur les lignes avec etab renseigné

cle<-paste0(table_finale$dep,table_finale$annee) #on regarde par département/année #ici pour chomage onutilise dep
depannee_vers_pop<-sapply(split(table_finale$extri,cle),sum,na.rm =TRUE)
table_finale$pop_dep_annee<-depannee_vers_pop[cle] #là ça me donne la pop définie par la somme des poids,

#si on veut la population de chômeur, rien de plus simple (actop =2 si actif inoccupé => donc chomeur)
#je filtre sur les tables finales où le deparc est renseigné (peu de perte parmi les salarié)

table_chomeur<-table_finale[table_finale$actop=="2",]
cle_chomeur<-paste0(table_chomeur$dep,table_chomeur$annee)
depannee_vers_nb_chom<-sapply(split(table_chomeur$extri,cle_chomeur),sum,na.rm=TRUE) #je somme les poids des chomeurs=> nb chomeur par depannee
table_finale$pop_chomeur_dep_annee<-depannee_vers_nb_chom[cle] #je mets la clé de la table complète ici, l'autre me servait juste pour le calcul


#On aggrege toutes les variables naf 4 sous le même nom naf 4
table_finale$naf4 = ifelse(table_finale$annee <= 2008, table_finale$nafg4, ifelse(table_finale$annee<= 2012, table_finale$nafg4n, table_finale$nafg004n))

table_finale<-table_finale[table_finale$deparc!="",] #j'enlève les deparc vite

#table_finale = table_finale[(table_finale$salmee < 120000) & (table_finale$salmee > 100),]
cle<-paste0(table_finale$deparc,table_finale$annee) #on regarde par département de l'établissement ici


dfterti <- table_finale[table_finale$naf4 == "EV",]
cle_terti<-paste0(dfterti$deparc,dfterti$annee) 
depannee_vers_tertiaire <- sapply(split(dfterti$extri,cle_terti),sum,na.rm =TRUE)
table_finale$dep_annee_terti = depannee_vers_tertiaire[cle]

dfindus <- table_finale[table_finale$naf4 == "ET",]
cle_indus = paste0(dfindus$deparc,dfindus$annee) 
depannee_vers_industrie <- sapply(split(dfindus$extri,cle_indus),sum,na.rm =TRUE)
table_finale$dep_annee_indu = depannee_vers_industrie[cle]

dfagri<- table_finale[table_finale$naf4 == "ES",]
cle_agri = paste0(dfagri$deparc,dfagri$annee) 
depannee_vers_agri <- sapply(split(dfagri$extri,cle_agri),sum,na.rm =TRUE)
table_finale$dep_annee_agri = depannee_vers_agri[cle]

dfconstru<- table_finale[table_finale$naf4 == "ES",]
cle_constru = paste0(dfconstru$deparc,dfconstru$annee) 
depannee_vers_constru <- sapply(split(dfconstru$extri,cle_constru),sum,na.rm =TRUE)
table_finale$dep_annee_constru = depannee_vers_constru[cle]

tauxtot = table_finale$dep_annee_agri + table_finale$dep_annee_indu + table_finale$dep_annee_constru + table_finale$dep_annee_terti
table_finale$tx_dep_annee_constru <- table_finale$dep_annee_constru/tauxtot * 100
table_finale$tx_dep_annee_agri <- table_finale$dep_annee_agri/tauxtot * 100
table_finale$tx_dep_annee_indu <- table_finale$dep_annee_indu/tauxtot * 100
table_finale$tx_dep_annee_terti <-table_finale$dep_annee_terti/tauxtot * 100
table_finale$tx_chomage = (table_finale$pop_chomeur_dep_annee / table_finale$pop_dep_annee) * 100



#Maintenant que j'ai récupéré mon taux de chômage je filtre sur les variables et salarié et actif occupé 
table_finale = table_finale[(table_finale$stat2 == "2" & table_finale$actop =="1") ,]


#Passage des dates et age en numérique

table_finale$annee<-as.integer(table_finale$annee)
table_finale$datdip<-as.integer(table_finale$datdip)
table_finale$datgen<-as.integer(table_finale$datgen)
table_finale$datsup<-as.integer(table_finale$datsup)
table_finale$ag<-as.integer(table_finale$ag)
table_finale$naia<-as.integer(table_finale$naia)

# ===


#expérience potentielle = expérience pro qu'aurait eu quelqu'un si il avait travailler toute sa vie en dehors de ses années d'études et de sa prime enfance
#= âge -annéesétudes (de 6ans à...) -6  # pour annee etude on fait ça à l'arrache car  datgen et datsup donnet des valeurs aberrantes

# ("1" = 23,"3" = 20,"4" = 18,"5" = 17,"6" = 14,"7" = 14) # on va approximer pour les études courtes, pour le sup on utilise datdip et datsup
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
#pareil je modifie juste la valeur 
chiffre_vers_lettre<-setNames(c("A","B","C","D","E","F","G","H","I","J"),seq(1,10))
table_finale$salmet[table_finale$annee %in% c("2013","2014")] <-chiffre_vers_lettre[table_finale$salmet[table_finale$annee %in% c("2013","2014")]]

#les départements, infos dep + je me cantonne à la france métropolitaine
table_finale[table_finale$deparc=="",]$deparc<-ifelse(table_finale[table_finale$deparc=="",]$annee %in% c("2013","2014"),table_finale[table_finale$deparc=="",]$edep,table_finale$dep)
table_finale$deparc[table_finale$deparc %in% c("97","99","9A","9B","9C","9D","9E","9F","9K")]<-"97"
table_finale$deparc[table_finale$deparc==""]<-"97" #Je mets dans 97 les 4000 non renseignés et (avec les dom)"
#table(table_finale$deparc)

#=========actualisation==========
#actualisation en euro 2013 (jusqu'a 1.18 de diff -> vaut le coup)
#actu_eur2013<-setNames(c(1.00, 1.00, 1.01, 1.03, 1.05, 1.07, 1.07, 1.10, 1.11, 1.13, 1.15, 1.18),2014:2003)
#table_finale$actu_eur13 = actu_eur2013[as.character(table_finale$annee)]
#table_finale$salmee<-as.numeric(table_finale$salmee)
#table_finale$salmee_actu <- table_finale$salmee * table_finale$actu_eur13


# ================================================


#recodage de salmet, je le renseigne pour les lignes qui ont répondu au salaire mais dont la tranche n'est de fait pas renseignée
table_finale$salmee<-as.numeric(table_finale$salmee)
table_finale$salmet<-ifelse(is.na(table_finale$salmee),table_finale$salmet,
                            ifelse(table_finale$salmee<500,"A",
                                   ifelse(table_finale$salmee<1000,"B",
                                          ifelse(table_finale$salmee<1250,"C",
                                                 ifelse(table_finale$salmee<1500,"D",
                                                        ifelse(table_finale$salmee<2000,"E",
                                                               ifelse(table_finale$salmee<2500,"F",
                                                                      ifelse(table_finale$salmee<3000,"G",
                                                                             ifelse(table_finale$salmee<5000,"H",
                                                                                    ifelse(table_finale$salmee<8000,"I",
                                                                                           "J"))))))))))

#Si on veut le salaire actualisé
# table_finale$salmet_actu<-ifelse(is.na(table_finale$salmee_actu),table_finale$salmet,
#                             ifelse(table_finale$salmee_actu<500,"A",
#                                    ifelse(table_finale$salmee_actu<1000,"B",
#                                           ifelse(table_finale$salmee_actu<1250,"C",
#                                                  ifelse(table_finale$salmee_actu<1500,"D",
#                                                         ifelse(table_finale$salmee_actu<2000,"E",
#                                                                ifelse(table_finale$salmee_actu<2500,"F",
#                                                                       ifelse(table_finale$salmee_actu<3000,"G",
#                                                                              ifelse(table_finale$salmee_actu<5000,"H",
#                                                                                     ifelse(table_finale$salmee_actu<8000,"I",
#                                                                                            "J"))))))))))


#filtre 15 - 65 ans
table_finale<-table_finale[table_finale$ag<=65 & table_finale$ag>=15,]

#diplôme en 4 catégories sans diplome, bac, licence, master et plus
#je mets en sans diplome tout ce qui est inférieur à bac
dip_nomme<-setNames(c("master et plus","master et plus",
                 "licence maîtrise","licence maîtrise",
                 "Bac+2","Bac+2","Bac+2","Bac+2",
                 "Bac","Bac","Bac",
                 "diplôme pro","diplôme pro","sans diplôme","sans diplôme","sans diplôme")
               ,c(10,12,21,22,30,31,32,33,41,42,43,44,50,60,70,71))
               
#J'appelle les variables comme dans le modele de la question 7
#diplome de l'individu
table_finale$sit_ind<-dip_nomme[table_finale$dip]


#la nationalité, variable immigr oui non si l'enquêté est issu de l'imigration
table_finale$immigre<-ifelse((table_finale$annee %in% c("2013","2014") & table_finale$nat14 != 10),1,
                             ifelse(((!table_finale$annee %in% c("2013","2014"))&table_finale$nat28 != 10),1,0))


#cser pour la csp de l'individu  
#cspp / m pour la csp du père et de la mère, je la met sur 1 position
table_finale$cspp<-substr(table_finale$cspp,1,1)
table_finale$cspm<-substr(table_finale$cspm,1,1)

#les anciens agri avec les agri
table_finale$cspp[table_finale$cspp=="7"]<-"1"
table_finale$cspm[table_finale$cspm=="7"]<-"1"


####Création de variables instrumentale pour le taux de diplômés dans le département

etab<-fread("C:/Users/Clement/Desktop/Projet Économétrie 2/Etablissements d'enseignement superieur.csv")
#etab<-fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/Etablissements d'enseignement superieur.csv")
etab$dep<-substr(etab$`Code département`,3,4)

tmp<-lapply(split(table_finale[,c("annee","deparc")],paste0(table_finale$annee,"_",table_finale$deparc)),function(x){
  #x<-split(table_finale[,c("annee","deparc")],paste0(table_finale$annee,"_",table_finale$deparc))[[1]]
  etab_concerne<-etab[etab$Date<=unique(x$annee) & etab$dep == unique(x$deparc)]
  t(colSums(etab_concerne[,c("Institut_Universitaire_de_Technologie","Institut_Universitaire_Professionnalisé","Université","Composante_universitaire","Ecole_ingénieurs" )],na.rm = TRUE))
})
tmp2<-do.call(rbind,tmp)
row.names(tmp2)<-names(tmp)

table_finale<-cbind(table_finale,tmp2[paste0(table_finale$annee,"_",table_finale$deparc),])
#pour chaque département x année j'ai donc le nombre d'écoles de chaque type qui était ouvertes


# =========================
#j'ajoute la creation d'etablissement sup (somme sur tous types)
#Pour chaque depXannee on veut le nombre d'établisssement crées dans le dep entre 4 et 6 ans avant

table_finale$annee_deparc<-paste0(table_finale$annee,"_",table_finale$dep)
table_finale$crea_4_6dernieres <- 0 # on met la valeure à 0 si 0 création d'étab 6 ans auparavant.
tmp<-lapply((2003:2014) ,function(date){
  #date=2003
  u = etab[etab$Date %in% (date-6):(date-4),]
  a = aggregate(u$Date, by = u[,c('dep')], length)
  a$annee_deparc = paste0(date,"_",a$dep)
  etab4_6 = setNames(a$x, a$annee_deparc)
  # class(etab4_6[cle])
  
})

dep_annee_vers_crea<-do.call(c,m) 
filtre<-table_finale$annee_deparc %in% names(dep_annee_vers_crea)
table_finale[filtre,]$crea_4_6dernieres<-dep_annee_vers_crea[table_finale[filtre,]$annee_deparc]


# salaire horaire et log salaire
# problème, beaucoup de NA dans nbheur (46000 / 140000 sur ce qu'on garde - là où pas de NA
# dans salmee/salmet etc) donc peut fiable
table_finale[table_finale$nbheur < 40]$nbheur <- 40 
table_finale$nbheur = ifelse(table_finale$nbheur > 250 | is.na(table_finale$nbheur), 150, table_finale$nbheur)
table_finale$salhor = table_finale$salmee / table_finale$nbheur

table_finale$log_salmee = log(table_finale$salmee)
table_finale$log_salhor = log(table_finale$salhor)
# =========================

#pour chaque département x année je calcule le pourcentage de diplômés du supérieur
table_finale$taux_dip_dep<-sapply(split(table_finale$sit_ind,paste0(table_finale$annee,"_",table_finale$dep)),function(x){
  #x<-split(table_finale$sit_ind,paste0(table_finale$annee,"_",table_finale$dep))$'2003_75'
  # head(x)
  (sum(x=="master et plus",na.rm = TRUE)/length(x))*100
  })[paste0(table_finale$annee,"_",table_finale$dep)]


#Pour que les variables de type ménage soient comparables
table_finale$typmen7[table_finale$typmen7 %in% c(5,6,9)]<-5
table_finale$typmen<-ifelse(table_finale$annee %in% c("2013","2014"),table_finale$typmen7,table_finale$typmen5)


###je prends la table pour df:
# table_finale<-fread("C:/Users/Clement/Desktop/Projet Économétrie 2/table_finale.csv")
  # tmp<-sapply(split(table_finale$ident_ind,table_finale$ident_ind),length)
  # ident_diff<-names(tmp[tmp>=2])
  # table_diff<-table_finale[table_finale$ident_ind %in% ident_diff,]
    
#J'efface ce qui ne sert plus

rm(list=ls()[ls()!="table_finale"])

# fwrite(table_diff,"C:/Users/Clement/Desktop/Projet Économétrie 2/table_diff.csv")

 fwrite(table_finale,"C:/Users/Clement/Desktop/Projet Économétrie 2/table_finale.csv")
 save.image(file="C:/Users/Clement/Desktop/Projet Économétrie 2/table_finale.Rdata")
#fwrite(table_finale,"C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.csv")
#save.image(file="C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.Rdata")


rm(list=ls())
gc()