rm(list=ls())
gc()
library(data.table)
library(readstata13)

#je source les libell�s de variables
#source("C:/Users/Clement/Desktop/Projet �conom�trie 2/Codes/libelle_variable.R")
source("C:/Users/Hugues/Desktop/Cours Ensae/econo/Codes/libelle_variable.R")
#########################################
####Liste des des variables par th�me####
#########################################
 
#=======================================
#Je rajoute : 
# - actualisation en euro 2013 (du coup faut tout relancer pour salmet)
# - taux chomage, retard 6eme (nb eleves avec 1 an retard en 6eme) et esp vie
#   des departements (j'avais pas vu que tu avais deja mis le chomage aha)
departements = fread('C:/Users/Hugues/Desktop/Cours Ensae/econo/Codes/departements.csv')
#departements = fread('C:/Users/Clement/Desktop/Projet �conom�trie 2/Codes/departements.csv')




####champ de l'�tude#### L'individu est d�limit� par ident noi
# 
# act #activit� au sens du bit# actif occupe 1 oui 2 non
# stat2 # statut de travail, saarie non slari, ce sont les salari�s qui  nous int�ressent
# stc #statu de la profession principale 1  son compte ou salari� chef d'entp, salari�(autre que ch d'entp) 3 taf pour sa famille
# actop# 1 oui non
# ident #identifiant anoymis� du logement
# noi # num�ro individuel
# noech #num�ro de l'�chantillon
# noicon #num�ro individuel du conjoint
# annee # annee de l'enquete
# trim # trimestre de l'enquete
# 
# 
# ####type de travail####
# 
# contrat #type de contrat de travail CDI CDD
# ancentr #(et ancentr4) anciennet� de l'entreprise en mois
# art #travail dans le milieu artistique  ?
# dchant#dur�e du chomage pr�c�dent l'emploi (peut expliquer unsaliaire faible si �lev�)
# dudet #dur�e du contrat de travail (joue sur le salaire ?)
# efen# effectif de l'entreprise
# efet # effectif de l'�tablissement
# naf # activit� �conomique de l'emploi occup�
# titc#type de fonctionnaire  eleve, titulaire ou contractuel
# 
# 
# ####Socio d�mographie####
# ag # age detai� ann�e r�volu
# typmen #type de m�nage
# typmen15 #idem 15 positions
# nbactoc # nombre actifs occup�s dans le logement
# nbagenf # nombre et age des enfants
# nat28 #nationalite
# naia #ann�e de naissance
# naim # mois de naissance
# cohab # vie en couple ?
# matri # statut matrimonial l�gal
# cse #CSP des actifs
# csei #idem non d�taill� 
# cspp #csp pere
# cspm #csp mere
# csptot # csp(pas forc�ment pour les actifs)
# sexe # sexe
# scj# sexe du conjoint
# so # statut d'occupation du logement
# 
# ###Localisation
# depeta #  ?
# deparc #code d�partement de l'�tablissem
# reg #r�gion de r�sidence
# 
# 
# ####Salaire####
# prim #compl�ment de primes dans le salaire
# revent #tranche de revenu annuel
# salmee # salaire d�clar� de l'emploi principal
# salmet #tranche de salaire d�clar� de l'emploi principal
# salred # salaire mensuel et redress� des non r�ponses
# 
# 
# ####Horaires et temps de travail####
# 
# sousempl#situation de sous emploi sans obj si ts complet ou inactif
# nbheur#nombre d'heures correspondant au salaire d�clar�
# nbhp #nombre d'heures normalement pr�vues par semaines
# hhc#nombre moyen d'heures par semaine dans l'emploi principal
# hhc6#idem 6 postes
# empnh # nb d'h"ueres sup
# emphre #nb d'heures sup r�mun�r�es
# jourtr #nombre moyen de jours travaill�s pendant la semaine
# tpp #temps de travail dans l'emploi principal, 1 temps complet 2 temps partiel
# 
# 
# ####Diplome####
# spe # specialite du diplome le plus �lev�
# nivet# niveau d'�tude le pus �lev�
# ngen #niveau d'�tude le plus �lev�
# cite97 # niveau d'�ducation le plus �lev� != diplome
# datdip #n'existe pas en 2003
# datgen # date du diplome dans l'enseignement g�n�al et secondaire
# datsup # date diplome dans l'enseignement sup�rierur
# ddipl#diplome le plus �lev� obtenu en 7 postes
# dip # idem 16 postes
# dip11 # idem 11 postes
# formoi # mois de fin des �tudes initiales
# fordat # ann�e de fin des �tudes initiales
# forsg #sp�cialit� suivie dans l'ennseignement secondaire


####On commence
###on charge les bases, on filtre sur les colonnes et les lignes

#ordonn�es par th�mes et ordre alphaetique dans haque th�mes
variable<-c("extri","extri15","actop","annee","ident","noi","noicon","stat2","stc","trim",
            "ancentr","art","contra","dchant","dudet","efen","efet","naf","titc","trefen","trefet",
            "ag","cohab","cse","csei","cser","cspm","cspp","cstot","matri","naia","naim","nat14","nat28","nbactoc","nbageenfa","nbagenf","scj","sexe","so","typmen5","typmen7","typmen21","typmen15",
            "deparc","depeta","reg","dep","edep","ancchomm","cstotr","associ","nafg021n","nafg021un","peun",
            "prim","revent","salmee","salmet","salred","congj","congjr","cstotcj","cstotprmcj","nafg004n","nafg4","nafg4n",
            "emphre","emphnh","hhc","hhc6","jourtr","nbheur","nbhp","sousempl","tpp","naf","naf1993","naf2003","NAFG88UN",
            "cite97","datdip","datgen","datsup","ddipl","dip","dip11","dipdet","fordat","formoi","forsg","ngen","nivet","spe")


#path = "C:/Users/Clement/Desktop/Projet �conom�trie 2/Donn�es"
path = "C:/Users/Hugues/Desktop/Cours Ensae/econo/nouvelles_donnees"
files = list.files(path)


# Concat�nation des bases 

fichier<-lapply(files[-c(1)],function(f){
  #f<-files[length(files)]
  data = read.dta13(paste0(path,"/",f))
  dif<-setdiff(variable,colnames(data))
  print(dif)
  #equivalences de noms si 2013 et 2014
  if(f %in% c("individu2013.dta","individu2014.dta")){
    tmp<-colnames(data)
    tmp[tmp=="dchantj"]<-"dchant" 
    tmp[tmp=="coured"]<-"cohab"
    tmp[tmp=="depeta"]<-"deparc" #fusion des variables d�partement
    tmp[tmp=="nbageenfa"]<-"nbagenf"
    tmp[tmp=="extri15"]<-"extri" #j'appelle les poids de la meme facon
    colnames(data)<-tmp
    }
  interet = data[ ,variable[variable %in% colnames(data)]]
  #
  })


table_finale = rbindlist(fichier, use.names = TRUE, fill = TRUE)

#Cr�ation de l'ident individu
table_finale$ident_ind<-paste0(table_finale$ident,"_",table_finale$noi)
#library(data.table)
# fwrite(table_finale,"C:/Users/Clement/Desktop/Projet �conom�trie 2/table_finale_1.csv")
 # table_finale<-fread("C:/Users/Clement/Desktop/Projet �conom�trie 2/table_finale_1.csv")
##################################################
## Cr�ation des variables au niveau d�partemental#
##################################################
#Filtre sur les lignes avec etab renseign�

cle<-paste0(table_finale$dep,table_finale$annee) #on regarde par d�partement/ann�e #ici pour chomage onutilise dep
depannee_vers_pop<-sapply(split(table_finale$extri,cle),sum,na.rm =TRUE)
table_finale$pop_dep_annee<-depannee_vers_pop[cle] #l� �a me donne la pop d�finie par la somme des poids,

#si on veut la population de ch�meur, rien de plus simple (actop =2 si actif inoccup� => donc chomeur)
#je filtre sur les tables finales o� le deparc est renseign� (peu de perte parmi les salari�)

table_chomeur<-table_finale[table_finale$actop=="2",]
cle_chomeur<-paste0(table_chomeur$dep,table_chomeur$annee)
depannee_vers_nb_chom<-sapply(split(table_chomeur$extri,cle_chomeur),sum,na.rm=TRUE) #je somme les poids des chomeurs=> nb chomeur par depannee
table_finale$pop_chomeur_dep_annee<-depannee_vers_nb_chom[cle] #je mets la cl� de la table compl�te ici, l'autre me servait juste pour le calcul


#On aggrege toutes les variables naf 4 sous le m�me nom naf 4
table_finale$naf4 = ifelse(table_finale$annee <= 2008, table_finale$nafg4, ifelse(table_finale$annee<= 2012, table_finale$nafg4n, table_finale$nafg004n))

table_finale<-table_finale[table_finale$deparc!="",] #j'enl�ve les deparc vite

#table_finale = table_finale[(table_finale$salmee < 120000) & (table_finale$salmee > 100),]
cle<-paste0(table_finale$deparc,table_finale$annee) #on regarde par d�partement de l'�tablissement ici


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



#Maintenant que j'ai r�cup�r� mon taux de ch�mage je filtre sur les variables et salari� et actif occup� 
table_finale = table_finale[(table_finale$stat2 == "2" & table_finale$actop =="1") ,]


#Passage des dates et age en num�rique

table_finale$annee<-as.integer(table_finale$annee)
table_finale$datdip<-as.integer(table_finale$datdip)
table_finale$datgen<-as.integer(table_finale$datgen)
table_finale$datsup<-as.integer(table_finale$datsup)
table_finale$ag<-as.integer(table_finale$ag)
table_finale$naia<-as.integer(table_finale$naia)

# ===


#exp�rience potentielle = exp�rience pro qu'aurait eu quelqu'un si il avait travailler toute sa vie en dehors de ses ann�es d'�tudes et de sa prime enfance
#= �ge -ann�es�tudes (de 6ans �...) -6  # pour annee etude on fait �a � l'arrache car  datgen et datsup donnet des valeurs aberrantes

# ("1" = 23,"3" = 20,"4" = 18,"5" = 17,"6" = 14,"7" = 14) # on va approximer pour les �tudes courtes, pour le sup on utilise datdip et datsup
dip_vers_annee_etude<-setNames(c(17, 14, 12, 11, 8, 8),c(1,3,4,5,6,7))
table_finale$annee_etude<-dip_vers_annee_etude[table_finale$ddipl]

# ddipl  : dipl�me le + �lev� obtenu
#- Dipl�me non d�clar�
#1 - Dipl�me sup�rieur
#3 - Baccalaur�at + 2 ans
#4 - Baccalaur�at ou brevet professionnel ou autre dipl�me de ce niveau
#5 - CAP, BEP ou autre dipl�me de ce niveau
#6 - Brevet des coll�ges
#7 - Aucun dipl�me ou CEP


#Exp�rience potentielle  = (�ge - nombre d'ann�es d'�tudes - six) =�ge-agedip
table_finale$exp_po =table_finale$ag - table_finale$annee_etude-6


#Petit retraitement de salmet, avant 2013 8 -> refus et apr�s 8 est utilis� comme une tranche => je mets ces lignes l� � 98 (comme pour 2013, 2014)
table_finale$salmet[table_finale$salmet=="8" & !(table_finale$annee %in% c("2013","2014"))]<-"98"
#pareil je modifie juste la valeur 
chiffre_vers_lettre<-setNames(c("A","B","C","D","E","F","G","H","I","J"),seq(1,10))
table_finale$salmet[table_finale$annee %in% c("2013","2014")] <-chiffre_vers_lettre[table_finale$salmet[table_finale$annee %in% c("2013","2014")]]

#les d�partements, infos dep + je me cantonne � la france m�tropolitaine
table_finale[table_finale$deparc=="",]$deparc<-ifelse(table_finale[table_finale$deparc=="",]$annee %in% c("2013","2014"),table_finale[table_finale$deparc=="",]$edep,table_finale$dep)
table_finale$deparc[table_finale$deparc %in% c("97","99","9A","9B","9C","9D","9E","9F","9K")]<-"97"
table_finale$deparc[table_finale$deparc==""]<-"97" #Je mets dans 97 les 4000 non renseign�s et (avec les dom)"
#table(table_finale$deparc)

#=========actualisation==========
#actualisation en euro 2013 (jusqu'a 1.18 de diff -> vaut le coup)
#actu_eur2013<-setNames(c(1.00, 1.00, 1.01, 1.03, 1.05, 1.07, 1.07, 1.10, 1.11, 1.13, 1.15, 1.18),2014:2003)
#table_finale$actu_eur13 = actu_eur2013[as.character(table_finale$annee)]
#table_finale$salmee<-as.numeric(table_finale$salmee)
#table_finale$salmee_actu <- table_finale$salmee * table_finale$actu_eur13


# ================================================


#recodage de salmet, je le renseigne pour les lignes qui ont r�pondu au salaire mais dont la tranche n'est de fait pas renseign�e
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

#Si on veut le salaire actualis�
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

#dipl�me en 4 cat�gories sans diplome, bac, licence, master et plus
#je mets en sans diplome tout ce qui est inf�rieur � bac
dip_nomme<-setNames(c("master et plus","master et plus",
                 "licence ma�trise","licence ma�trise",
                 "Bac+2","Bac+2","Bac+2","Bac+2",
                 "Bac","Bac","Bac",
                 "dipl�me pro","dipl�me pro","sans dipl�me","sans dipl�me","sans dipl�me")
               ,c(10,12,21,22,30,31,32,33,41,42,43,44,50,60,70,71))
               
#J'appelle les variables comme dans le modele de la question 7
#diplome de l'individu
table_finale$sit_ind<-dip_nomme[table_finale$dip]


#la nationalit�, variable immigr oui non si l'enqu�t� est issu de l'imigration
table_finale$immigre<-ifelse((table_finale$annee %in% c("2013","2014") & table_finale$nat14 != 10),1,
                             ifelse(((!table_finale$annee %in% c("2013","2014"))&table_finale$nat28 != 10),1,0))


#cser pour la csp de l'individu  
#cspp / m pour la csp du p�re et de la m�re, je la met sur 1 position
table_finale$cspp<-substr(table_finale$cspp,1,1)
table_finale$cspm<-substr(table_finale$cspm,1,1)

#les anciens agri avec les agri
table_finale$cspp[table_finale$cspp=="7"]<-"1"
table_finale$cspm[table_finale$cspm=="7"]<-"1"


####Cr�ation de variables instrumentale pour le taux de dipl�m�s dans le d�partement
#table_finale<-fread("C:/Users/Clement/Desktop/Projet �conom�trie 2/table_finale.csv")

#etab<-fread("C:/Users/Clement/Desktop/Projet �conom�trie 2/Etablissements d'enseignement superieur.csv")
etab<-fread("C:/Users/Hugues/Desktop/Cours Ensae/econo/Etablissements d'enseignement superieur.csv")
etab$dep<-substr(etab$`Code d�partement`,3,4)


# =========================
#j'ajoute la creation d'etablissement sup (somme sur tous types)
#Pour chaque depXannee on veut le nombre d'�tablisssement cr�es dans le dep entre 4 et 6 ans avant

table_finale$annee_deparc<-paste0(table_finale$annee,"_",table_finale$dep)

table_finale$crea_4_6_dernieres <- 0 # on met la valeure � 0 si 0 cr�ation d'�tab 6 ans auparavant.
tmp<-lapply((2003:2014) ,function(date){
  #date=2003
  u = etab[etab$Date %in% (date-6):(date-4),]
  a = aggregate(u$Date, by = u[,c('dep')], length)
  a$annee_deparc = paste0(date,"_",a$dep)
  etab4_6 = setNames(a$x, a$annee_deparc)
  # class(etab4_6[cle])
  })

dep_annee_vers_crea<-do.call(c,tmp) 
filtre<-table_finale$annee_deparc %in% names(dep_annee_vers_crea)
table_finale[filtre,]$crea_4_6_dernieres<-dep_annee_vers_crea[table_finale[filtre,]$annee_deparc]

table_finale$crea_4_6_dernieres_sup <- 0 # on met la valeure � 0 si 0 cr�ation d'�tab 6 ans auparavant.
tmp<-lapply((2003:2014) ,function(date){
  #date=2003
  u = etab[etab$Date %in% (date-6):(date-4) & etab$Ecole_ing�nieurs ==1 | etab$Universit� ==1 | etab$Composante_universitaire == 1 ,]
  a = aggregate(u$Date, by = u[,c('dep')], length)
  a$annee_deparc = paste0(date,"_",a$dep)
  etab4_6 = setNames(a$x, a$annee_deparc)
  # class(etab4_6[cle])
})

dep_annee_vers_crea<-do.call(c,tmp) 
filtre<-table_finale$annee_deparc %in% names(dep_annee_vers_crea)
table_finale[filtre,]$crea_4_6_dernieres_sup<-dep_annee_vers_crea[table_finale[filtre,]$annee_deparc]



table_finale$crea_5_10_dernieres <- 0 # on met la valeure � 0 si 0 cr�ation d'�tab 6 ans auparavant.
tmp<-lapply((2003:2014) ,function(date){
  #date=2003
  u = etab[etab$Date %in% (date-10):(date-5),]
  a = aggregate(u$Date, by = u[,c('dep')], length)
  a$annee_deparc = paste0(date,"_",a$dep)
  etab5_10 = setNames(a$x, a$annee_deparc)
  # class(etab4_6[cle])
  
})

dep_annee_vers_crea<-do.call(c,tmp) 
filtre<-table_finale$annee_deparc %in% names(dep_annee_vers_crea)
table_finale[filtre,]$crea_5_10_dernieres<-dep_annee_vers_crea[table_finale[filtre,]$annee_deparc]



table_finale$crea_5_10_dernieres_sup <- 0 # on met la valeure � 0 si 0 cr�ation d'�tab 6 ans auparavant.
tmp<-lapply((2003:2014) ,function(date){
  #date=2003
  u = etab[etab$Date %in% (date-10):(date-5) & etab$Ecole_ing�nieurs ==1 | etab$Universit� ==1 | etab$Composante_universitaire == 1 ,]
  
  a = aggregate(u$Date, by = u[,c('dep')], length)
  a$annee_deparc = paste0(date,"_",a$dep)
  etab5_10 = setNames(a$x, a$annee_deparc)
  # class(etab4_6[cle])
  
})


dep_annee_vers_crea<-do.call(c,tmp) 
filtre<-table_finale$annee_deparc %in% names(dep_annee_vers_crea)
table_finale[filtre,]$crea_5_10_dernieres_sup<-dep_annee_vers_crea[table_finale[filtre,]$annee_deparc]



# salaire horaire et log salaire
# probl�me, beaucoup de NA dans nbheur (46000 / 140000 sur ce qu'on garde - l� o� pas de NA
# dans salmee/salmet etc) donc peut fiable
table_finale[table_finale$nbheur < 40]$nbheur <- 40 
table_finale$nbheur = ifelse(table_finale$nbheur > 250 | is.na(table_finale$nbheur), 150, table_finale$nbheur)
table_finale$salhor = table_finale$salmee / table_finale$nbheur

table_finale$log_salmee = log(table_finale$salmee)
table_finale$log_salhor = log(table_finale$salhor)
# =========================

#pour chaque d�partement x ann�e je calcule le pourcentage de dipl�m�s du sup�rieur
# table_finale<-fread("C:/Users/Clement/Desktop/Projet �conom�trie 2/table_finale.csv")

table_finale$taux_dip_dep<-sapply(split(table_finale$sit_ind,paste0(table_finale$annee,"_",table_finale$dep)),function(x){
  #x<-split(table_finale$sit_ind,paste0(table_finale$annee,"_",table_finale$dep))$'2003_75'
  # head(x)
  liste_sup<-c("master et plus","licence ma�trise","licence ma�trise","Bac+2")
  (sum(x %in% liste_sup,na.rm = TRUE)/length(x))*100
  })[paste0(table_finale$annee,"_",table_finale$dep)]


#Pour que les variables de type m�nage soient comparables
table_finale$typmen7[table_finale$typmen7 %in% c(5,6,9)]<-5
table_finale$typmen<-ifelse(table_finale$annee %in% c("2013","2014"),table_finale$typmen7,table_finale$typmen5)



rm(list=ls()[ls()!="table_finale"])

# fwrite(table_diff,"C:/Users/Clement/Desktop/Projet �conom�trie 2/table_diff.csv")

#fwrite(table_finale,"C:/Users/Clement/Desktop/Projet �conom�trie 2/table_finale.csv")
#save.image(file="C:/Users/Clement/Desktop/Projet �conom�trie 2/table_finale.Rdata")
fwrite(table_finale,"C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.csv")
save.image(file="C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.Rdata")


rm(list=ls())
gc()