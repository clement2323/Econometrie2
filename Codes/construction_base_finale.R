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
            "deparc","depeta","reg","dep","edep","ancchomm","cstotr","associ",
            "prim","revent","salmee","salmet","salred","congj","congjr","cstotcj","cstotprmcj",
            "emphre","emphnh","hhc","hhc6","jourtr","nbheur","nbhp","sousempl","tpp",
            "cite97","datdip","datgen","datsup","ddipl","dip","dip11","dipdet","fordat","formoi","forsg","ngen","nivet","spe")


path = "C:/Users/Clement/Desktop/Projet Économétrie 2/Données"
#path = "C:/Users/Hugues/Desktop/Cours Ensae/econo/nouvelles_donnees"
files = list.files(path)

sort(colnames(data))
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

#test pour voir qu'on a bien 6 interrogation a peu près par indiv + création de l'identifiant de l'indiv au passage id_ind<-iden+noi

table_finale$ident_ind<-paste0(table_finale$ident,"_",table_finale$noi)
#seuls les trim 1 ont été gardés
#tmp<-sapply(split(paste0(table_finale$annee,"_",table_finale$trim),table_finale$ident),length)

#Variable au niveau départemental
cle<-paste0(table_finale$dep,table_finale$annee) #on regarde par département/année
#pop
depannee_vers_pop<-sapply(split(table_finale$extri,cle),sum,na.rm =TRUE)
table_finale$pop_dep_annee<-depannee_vers_pop[cle] #là ça me donne la pop définie par la somme des poids,

#si on veut la population de chômeur, rien de plus simple (actop =2 si actif inoccupé => donc chomeur)
table_chomeur<-table_finale[table_finale$actop=="1",]
cle_chomeur<-paste0(table_chomeur$dep,table_chomeur$annee)

depannee_vers_nb_chom<-sapply(split(table_chomeur$extri,cle_chomeur),sum,na.rm=TRUE) #je somme les poids des chomeurs=> nb chomeur par depannee
table_finale$pop_chomeur_dep_annee<-depannee_vers_nb_chom[cle] #je mets la clé de la table complète ici, l'autre me servait juste pour le calcul

#TO DO TROUVER d'autres idées de var niveau dep, pop qu travaille dans l'industrie etc ??


#je nomme le



#ok je filtre sur les variables et salarié et actif occupé 
table_finale = table_finale[(table_finale$stat2 == "2" & table_finale$actop =="1") ,]
table_finale$ident_temps<-paste0(table_finale$annee,"_",table_finale$trim)

#Passage des dates et age en numérique

table_finale$annee<-as.integer(table_finale$annee)
table_finale$datdip<-as.integer(table_finale$datdip)
table_finale$datgen<-as.integer(table_finale$datgen)
table_finale$datsup<-as.integer(table_finale$datsup)
table_finale$ag<-as.integer(table_finale$ag)
table_finale$naia<-as.integer(table_finale$naia)

# ===
table_finale$congj = ifelse(is.na(table_finale$congj), table_finale$congjr, table_finale$congj)
table_finale$cstotcj = ifelse(is.na(table_finale$cstotcj), table_finale$cstotprmcj, table_finale$cstotcj)
# ===


#nombre années études j'abandonne l'idée d'utiliser datsup dat gen datdip
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
actu_eur2013<-setNames(c(1.00, 1.00, 1.01, 1.03, 1.05, 1.07, 1.07, 1.10, 1.11, 1.13, 1.15, 1.18),2014:2003)
table_finale$actu_eur13 = actu_eur2013[as.character(table_finale$annee)]
table_finale$salmee<-as.numeric(table_finale$salmee)
table_finale$salmee_actu <- table_finale$salmee * table_finale$actu_eur13



#deparc change en depeta
#table_finale$deparc <- ifelse(table_finale$deparc == "", table_finale$depeta, table_finale$deparc)

#ret6m : retard d'un an en sixième
ret = setNames(as.character(departements$ret_6m), departements$num)
table_finale$ret6m <- ret[as.character(table_finale$deparc)]

#esp de vie
esp = setNames(as.character(departements$esp_vie), departements$num)
table_finale$esp_vie <- esp[as.character(table_finale$deparc)]

#moyenne chomage sur annees 2003 2014
chom = setNames(as.character(departements$chomage_moy), departements$num)
table_finale$tx_chomage <- chom[as.character(table_finale$deparc)]

# fin ajouts
# ================================================


##recodage de salmet, je le renseigne pour les lignes qui ont répondu au salaire mais dont la tranche n'est de fait pas renseignée
#table(table_finale$salmet)
#sum(table_finale$salmet=="");sum(is.na(table_finale$salmee))
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

table_finale$salmet_actu<-ifelse(is.na(table_finale$salmee_actu),table_finale$salmet,
                            ifelse(table_finale$salmee_actu<500,"A",
                                   ifelse(table_finale$salmee_actu<1000,"B",
                                          ifelse(table_finale$salmee_actu<1250,"C",
                                                 ifelse(table_finale$salmee_actu<1500,"D",
                                                        ifelse(table_finale$salmee_actu<2000,"E",
                                                               ifelse(table_finale$salmee_actu<2500,"F",
                                                                      ifelse(table_finale$salmee_actu<3000,"G",
                                                                             ifelse(table_finale$salmee_actu<5000,"H",
                                                                                    ifelse(table_finale$salmee_actu<8000,"I",
                                                                                           "J"))))))))))


#filtre 15 - 65 ans
table_finale<-table_finale[table_finale$ag<=65 & table_finale$ag>=15,]
#Il restait quelques aberrations

# library(data.table)
# table_finale<-fread("C:/Users/Clement/Desktop/Projet Économétrie 2/table_finale.csv")

#diplôme en 4 catégories sans diplome, bac, licence, master et plus
#jemets en sans diplome tout ce qui est inférieur à bac
dip_nomme<-setNames(c("master et plus","master et plus",
                 "licence maîtrise","licence maîtrise",
                 "Bac+2","Bac+2","Bac+2","Bac+2",
                 "Bac","Bac","Bac",
                 "diplôme pro","diplôme pro","sans diplôme","sans diplôme","sans diplôme")
               ,c(10,12,21,22,30,31,32,33,41,42,43,44,50,60,70,71))
               
#J'appelle les variables comme dans le modele de la question 7
table_finale$sit_ind<-dip_nomme[table_finale$dip]


#la nationalité, variable immigr oui non si l'enquêté est issu de l'imigration
table_finale$immigre<-ifelse((table_finale$annee %in% c("2013","2014") & table_finale$nat14 != 10),1,
                             ifelse(((!table_finale$annee %in% c("2013","2014"))&table_finale$nat28 != 10),1,0))


#cser pour la csp de l'individu  
#cspp / m pour la csp du père et de la mère, je la laisse en une position
table_finale$cspp<-substr(table_finale$cspp,1,1)
table_finale$cspm<-substr(table_finale$cspm,1,1)

table_finale$cspp[table_finale$cspp=="7"]<-"1"
table_finale$cspm[table_finale$cspm=="7"]<-"1"
#les anciens agri avec les agri

# reproduction sociale
# round(prop.table(table(table_finale$cspp,table_finale$sit_ind),1)*100,0)



#chomage par département, provient des données insee du RP2015 

#chomage_dep<-fread("C:/Users/Clement/Desktop/Projet Économétrie 2/chomage_dep.csv")
#chomage_dep$dep<-substr(chomage_dep$dep,1,2)
 
#dep_vers_taux_chom<-sapply(split(chomage_dep[,c("homme_chomeur","femme_chomeur","homme_emploi","femme_emploi")],chomage_dep$dep),function(x){
# x<-split(chomage_dep[,c("homme_chomeur","femme_chomeur","homme_emploi","femme_emploi")],chomage_dep$dep)$'97'
#   x<-colSums(x)
#  unname(((x[1]+x[2])/(sum(x)))*100)
#  })
#chomage_dep$taux_chom<-(chomage_dep$homme_chomeur+chomage_dep$femme_chomeur)/(chomage_dep$homme_chomeur+chomage_dep$femme_chomeur+chomage_dep$homme_emploi+chomage_dep$femme_emploi)*100
#table_finale$taux_chom<-dep_vers_taux_chom[table_finale$deparc]

#Les établissements
etab<-fread("C:/Users/Clement/Desktop/Projet Économétrie 2/Etablissements d'enseignement superieur.csv")
#etab<-fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/Etablissements d'enseignement superieur.csv")
etab$dep<-substr(etab$`Code département`,3,4)

tmp<-lapply(split(table_finale[,c("annee","deparc")],paste0(table_finale$annee,"_",table_finale$deparc)),function(x){
  #x<-split(table_finale[,c("annee","deparc")],paste0(table_finale$annee,"_",table_finale$deparc))[[1]]
  etab_concerne<-etab[etab$Date<=unique(x$annee) & etab$dep == unique(x$deparc)]
  #je vais sommer l'ensemble des écoles dispo
  t(colSums(etab_concerne[,c("Institut_Universitaire_de_Technologie","Institut_Universitaire_Professionnalisé","Université","Composante_universitaire","Ecole_ingénieurs" )],na.rm = TRUE))
})
tmp2<-do.call(rbind,tmp)
row.names(tmp2)<-names(tmp)

table_finale<-cbind(table_finale,tmp2[paste0(table_finale$annee,"_",table_finale$deparc),])
#pour chaque département x année j'ai donc le nombre d'écoles de chaque type qui était ouvertes


# =========================
#j'ajoute la creation d'etablissement sup (somme sur tous types)
etab_recent = etab[etab$Date >= 2003,]
crea_etab = aggregate(etab_recent$dep, by = etab_recent[, c('Date','dep')], length)
crea_etab$annee_deparc = paste0(crea_etab$Date,"_",crea_etab$dep)
crea_etab = setNames(crea_etab$x, crea_etab$annee_deparc)

table_finale$annee_deparc = paste0(table_finale$annee,"_",table_finale$deparc)
table_finale$crea_etab <- crea_etab[table_finale$annee_deparc]
table_finale[is.na(table_finale$crea_etab),]$crea_etab <- 0


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

table(table_finale$typmen)
#J'efface ce qui ne sert plus

rm(list=ls()[ls()!="table_finale"])

#Rq à ce stade je n'ai pas filtré sur les valeurs manquantes de salaire

#Save en Rdata et en csv

fwrite(table_finale,"C:/Users/Clement/Desktop/Projet Économétrie 2/table_finale.csv")
save.image(file="C:/Users/Clement/Desktop/Projet Économétrie 2/table_finale.Rdata")

# fwrite(table_finale,"C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.csv")
# save.image(file="C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.Rdata")


rm(list=ls())
gc()