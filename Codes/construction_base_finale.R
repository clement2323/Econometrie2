rm(list=ls())
gc()
library(data.table)
library(readstata13)

#########################################
####Liste des des variables par th�me####
#########################################
 

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
variable<-c("actop","annee","ident","noi","noicon","stat2","stc","trim",
            "ancentr","art","contra","dchant","dudet","efen","efet","naf","titc","trefen","trefet",
            "ag","cohab","cse","csei","cspm","cspp","cstot","matri","naia","naim","nat14","nat28","nbactoc","nbageenfa","nbagenf","scj","sexe","so","typmen5","typmen7","typmen21","typmen15",
            "deparc","depeta","reg",
            "prim","revent","salmee","salmet","salred",
            "emphre","emphnh","hhc","hhc6","jourtr","nbheur","nbhp","sousempl","tpp",
            "cite97","datdip","datgen","datsup","ddipl","dip","dip11","fordat","formoi","forsg","ngen","nivet","spe")


path = "C:/Users/Clement/Desktop/Projet �conom�trie 2/Donn�es"
files = list.files(path)
# variables = c("annee","trim","ag","salmee","salmet","datdip","datgen","datsup","ddipl","deparc","depeta")


#Pour l'instant jej d�gage la grosse table des vieilles ann�es trop lourdes.
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
  })

table_finale = rbindlist(fichier, use.names = TRUE, fill = TRUE)

#test pour voir qu'on a bien 6 interrogation a peu pr�s par indiv + cr�ation de l'identifiant de l'indiv au passage id_ind<-iden+noi

table_finale$ident_ind<-paste0(table_finale$ident,"_",table_finale$noi)
#au niveau de l'indiv on a max 2interrogation, regardons au niveau du logement (on esp�re avoir 6 pour 6 trimestres..)
tmp<-sapply(split(paste0(table_finale$annee,"_",table_finale$trim),table_finale$ident),length)
#ARf... � demande, on devait avoir 6 fois le logement dans la base en moyenne..

#ok je filtre sur les variables et salari� et actif occup� 
table_finale = table_finale[(table_finale$stat2 == "2" & table_finale$actop =="1") ,]


#Passage des dates et age en num�rique

table_finale$annee<-as.integer(table_finale$annee)
table_finale$datdip<-as.integer(table_finale$datdip)
table_finale$datgen<-as.integer(table_finale$datgen)
table_finale$datsup<-as.integer(table_finale$datsup)
table_finale$ag<-as.integer(table_finale$ag)
table_finale$naia<-as.integer(table_finale$naia)


#nombre ann�es �tudes j'abandonne l'id�e d'utiliser datsup dat gen datdip
#exp�rience potentielle = exp�rience pro qu'aurait eu quelqu'un si il avait travailler toute sa vie en dehors de ses ann�es d'�tudes et de sa prime enfance
#= �ge -ann�es�tudes (de 6ans �...) -6  # pour annee etude on fait �a � l'arrache car  datgen et datsup donnet des valeurs aberrantes

# ("1" = 23,"3" = 20,"4" = 18,"5" = 17,"6" = 14,"7" = 14) # on va approxmer pour les �tudes courtes, pour le sup on utilise datdip et datsup
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


#J'efface ce qui ne sert plus
rm(list=ls()[ls()!="table_finale"])




#Rq � ce stade je n'ai pas filtr� sur les valeurs manquantes de salaire


#Save en Rdata et en csv
fwrite(table_finale,"C:/Users/Clement/Desktop/Projet �conom�trie 2/table_finale.csv")
save.image(file="C:/Users/Clement/Desktop/Projet �conom�trie 2/table_finale.Rdata")

rm(list=ls())
gc()