#Fichier à sourcr avec les formats
#Stat desc
#création des vecteurs nommés avec leurs libellés avec un set names

#dipl le plus eleve obtenu
ddipl_lib<-setNames(c("Diplôme non déclaré",
  "Diplôme supérieur","Baccalauréat + 2 ans",
  "Baccalauréat/brevet pro",
  "CAP/BEP",
  "Brevet des collèges",
  "Aucun diplôme ou CEP"),c("",1,3,4,5,6,7))
  
# NBAGEENFA ok
# Nombre et âge (à la fin de la semaine de référence) des enfants du ménage
 nbageenfa_lib<-setNames(c("Aucun enfant de moins de 18 ans",
 "Un enfant de 6 à 17 ans",
 "Un enfant de 3 à 5 ans",
 "Un enfant de moins de 3 ans",
 "Deux enfants, dont le plus jeune a de 6 à 17 ans",
 "Deux enfants, dont le plus jeune a de 3 à 5 ans",
 "Deux enfants, dont le plus jeune a moins de 3 ans",
 "Trois enfants ou plus, dont le plus jeune a de 6 à 17 ans",
 "Trois enfants ou plus, dont le plus jeune a de 3 à 5 ans",
 "Trois enfants ou plus, dont le plus jeune a moins de 3 ans"),seq(0,9))
# Variable remplaçant à partir de 2013 la variable NBAGENF présente dans les base avant

cspp_nomme<-setNames(
  c("Non renseigné",
    "Agriculteurs",
    "Agriculteurs sur petite exploitation",
    "Agriculteurs sur moyenne exploitation",
    "Agriculteurs sur grande exploitation",
    "Artisans",
    "Commerçants et assimilés",
    "Chefs d'entreprise de 10 salariés ou plus",
    "Professions libérales",
    "Cadres de la fonction publique",
    "Professeurs, professions scientifiques",
    "Professions de l'information, des arts et des spectacles",
    "Cadres administratifs et commerciaux d'entreprises",
    "Ingénieurs et cadres techniques d'entreprises",
    "Instituteurs et assimilés",
    "Professions intermédiaires de la santé et du travail social",
    "Clergé, religieux",
    "Professions intermédiaires administratives de la fonction publique",
    "Professions intermédiaires administratives et commerciales des entreprises",
    "Techniciens",
    "Contremaîtres, agents de maîtrise",
    "Employés civils et agents de service de la fonction publique",
    "Policiers et militaires",
    "Employés administratifs d'entreprises",
    "Employés de commerce",
    "Personnels des services directs aux particuliers",
    "Ouvriers qualifiés de type industriel",
    "Ouvriers qualifiés de type artisanal",
    "Chauffeurs",
    "Ouvriers qualifiés de la manutention, du magasinage et du transport",
    "Ouvriers non qualifiés de type industriel",
    "Ouvriers non qualifiés de type artisanal",
    "Ouvriers agricoles",
    "Anciens agriculteurs exploitants",
    "Anciens artisans, commerçants, chefs d'entreprise",
    "Anciens cadres",
    "Anciennes professions intermédiaires",
    "Anciens employés",
    "Anciens ouvriers",
    "Chômeurs n'ayant jamais travaillé",
    "Autres personnes sans activité professionnelle"),c(00,
10,11,12,13,21,22,23,31,33,34,35,37,38,42,43,44,45,46,47,48,52,53,54,55,56,62,63,64,65,67,68,69,71,72,74,75,77,78,81,82))


#dip, diplôme le plus élevé en 16 postes
dip_libelle<-setNames(c("Non renseigné","Master (recherche ou professionnel),DEA,DESS,Doctorat","Ecoles niveau licence et au-delà","Maîtrise (M1)"," Licence (L3)","DEUG","DUT-BTS","Autre diplôme (niveau bac+2)","Paramédical et social (niveau bac+2)","Baccalauréat général"," Bac technologique","Bac professionnel","Brevet de technicien-brevet professionnel","CAP-BEP","Brevet des collèges","Certificat d'études primaires","Sans diplôme"),
                      c("",10,12,22,21,30,31,32,33,41,42,43,44,50,60,70,71))


salmet_libelle<-setNames(
c("Sans objet","Refus","Moins de 500 ???","De 500 ??? à moins de 1000 ???","De 1000 ??? à moins de 1250 ???",
"De 1250 ??? à moins de 1500 ???",
"De 1500 ??? à moins de 2000 ???",
"De 2000 ??? à moins de 2500 ???",
"De 2500 ??? à moins de 3000 ???",
"De 3000 ??? à moins de 5000 ???",
"De 5000 ??? à moins de 8000 ???",
"Plus de 8000 ???","Ne sait pas",
"Moins de 500 ???","De 500 ??? à moins de 1000 ???","De 1000 ??? à moins de 1250 ???",
"De 1250 ??? à moins de 1500 ???",
"De 1500 ??? à moins de 2000 ???",
"De 2000 ??? à moins de 2500 ???",
"De 2500 ??? à moins de 3000 ???",
"De 3000 ??? à moins de 5000 ???",
"De 5000 ??? à moins de 8000 ???","Plus de 8000 ???"),c("","98","A","B","C","D","E","F","G","H","I","J","99","1","2","3","4","5","6","7","8","9","10"))

