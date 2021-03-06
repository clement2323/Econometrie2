#Fichier � sourcr avec les formats
#Stat desc
#cr�ation des vecteurs nomm�s avec leurs libell�s avec un set names

# CSER char 1 Cat�gorie socioprofessionnelle pour les
# actifs (niveau agr�g�, PCS2003 ou PCS)
# - Sans objet (inactif)
# 0 - Non renseign�
# 1 - Agriculteurs exploitants
# 2 - Artisans, commer�ants et chefs d'entreprise
# 3 - Cadres et professions intellectuelles sup�rieures
# 4 - Professions interm�diaires
# 5 - Employ�s
# 6 - Ouvriers
# 8 - Ch�meurs n'ayant jamais travaill� ou militaires du contingent

# 
# 1 M�nage d'une seule personne
# 2 Famille monoparentale
# 3 Couple sans enfant
# 4 Couple avec enfant(s)
# 5 M�nage de plusieurs personnes ayant toutes un lien de parent� avec la personne de r�f�rence
# du m�nage, ni couple, ni famille monoparentale


#dipl le plus eleve obtenu
ddipl_lib<-setNames(c("Dipl�me non d�clar�",
  "sup","Bac+2",
  "Bac",
  "CAP",
  "Brevet",
  "CEP"),c("",1,3,4,5,6,7))
  
# NBAGEENFA ok
# Nombre et �ge (� la fin de la semaine de r�f�rence) des enfants du m�nage
 nbageenfa_lib<-setNames(c("Aucun enfant de moins de 18 ans",
 "Un enfant de 6 � 17 ans",
 "Un enfant de 3 � 5 ans",
 "Un enfant de moins de 3 ans",
 "Deux enfants, dont le plus jeune a de 6 � 17 ans",
 "Deux enfants, dont le plus jeune a de 3 � 5 ans",
 "Deux enfants, dont le plus jeune a moins de 3 ans",
 "Trois enfants ou plus, dont le plus jeune a de 6 � 17 ans",
 "Trois enfants ou plus, dont le plus jeune a de 3 � 5 ans",
 "Trois enfants ou plus, dont le plus jeune a moins de 3 ans"),seq(0,9))
# Variable rempla�ant � partir de 2013 la variable NBAGENF pr�sente dans les base avant

cspp_nomme<-setNames(
  c("Non renseign�",
    "Agriculteurs",
    "Agriculteurs sur petite exploitation",
    "Agriculteurs sur moyenne exploitation",
    "Agriculteurs sur grande exploitation",
    "Artisans",
    "Commer�ants et assimil�s",
    "Chefs d'entreprise de 10 salari�s ou plus",
    "Professions lib�rales",
    "Cadres de la fonction publique",
    "Professeurs, professions scientifiques",
    "Professions de l'information, des arts et des spectacles",
    "Cadres administratifs et commerciaux d'entreprises",
    "Ing�nieurs et cadres techniques d'entreprises",
    "Instituteurs et assimil�s",
    "Professions interm�diaires de la sant� et du travail social",
    "Clerg�, religieux",
    "Professions interm�diaires administratives de la fonction publique",
    "Professions interm�diaires administratives et commerciales des entreprises",
    "Techniciens",
    "Contrema�tres, agents de ma�trise",
    "Employ�s civils et agents de service de la fonction publique",
    "Policiers et militaires",
    "Employ�s administratifs d'entreprises",
    "Employ�s de commerce",
    "Personnels des services directs aux particuliers",
    "Ouvriers qualifi�s de type industriel",
    "Ouvriers qualifi�s de type artisanal",
    "Chauffeurs",
    "Ouvriers qualifi�s de la manutention, du magasinage et du transport",
    "Ouvriers non qualifi�s de type industriel",
    "Ouvriers non qualifi�s de type artisanal",
    "Ouvriers agricoles",
    "Anciens agriculteurs exploitants",
    "Anciens artisans, commer�ants, chefs d'entreprise",
    "Anciens cadres",
    "Anciennes professions interm�diaires",
    "Anciens employ�s",
    "Anciens ouvriers",
    "Ch�meurs n'ayant jamais travaill�",
    "Autres personnes sans activit� professionnelle"),c(00,
10,11,12,13,21,22,23,31,33,34,35,37,38,42,43,44,45,46,47,48,52,53,54,55,56,62,63,64,65,67,68,69,71,72,74,75,77,78,81,82))


#dip, dipl�me le plus �lev� en 16 postes
dip_libelle<-setNames(c("Non renseign�","Master (recherche ou professionnel),DEA,DESS,Doctorat","Ecoles niveau licence et au-del�","Ma�trise (M1)"," Licence (L3)","DEUG","DUT-BTS","Autre dipl�me (niveau bac+2)","Param�dical et social (niveau bac+2)","Baccalaur�at g�n�ral"," Bac technologique","Bac professionnel","Brevet de technicien-brevet professionnel","CAP-BEP","Brevet des coll�ges","Certificat d'�tudes primaires","Sans dipl�me"),
                      c("",10,12,22,21,30,31,32,33,41,42,43,44,50,60,70,71))


salmet_libelle<-setNames(
c("Sans objet","Refus","Moins de 500 ???","De 500 ??? � moins de 1000 ???","De 1000 ??? � moins de 1250 ???",
"De 1250 ??? � moins de 1500 ???",
"De 1500 ??? � moins de 2000 ???",
"De 2000 ??? � moins de 2500 ???",
"De 2500 ??? � moins de 3000 ???",
"De 3000 ??? � moins de 5000 ???",
"De 5000 ??? � moins de 8000 ???",
"Plus de 8000 ???","Ne sait pas",
"Moins de 500 ???","De 500 ??? � moins de 1000 ???","De 1000 ??? � moins de 1250 ???",
"De 1250 ??? � moins de 1500 ???",
"De 1500 ??? � moins de 2000 ???",
"De 2000 ??? � moins de 2500 ???",
"De 2500 ??? � moins de 3000 ???",
"De 3000 ??? � moins de 5000 ???",
"De 5000 ??? � moins de 8000 ???","Plus de 8000 ???"),c("","98","A","B","C","D","E","F","G","H","I","J","99","1","2","3","4","5","6","7","8","9","10"))

