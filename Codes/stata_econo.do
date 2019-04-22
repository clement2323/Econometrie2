//******TD1*******//
clear all // Tout syupprimer, code et variables
drop _all // Effacer toutes les variables 

//ctrl + D pour executer ligne de commande sélectionnée
// Déclarer un répertoire de travail 

cd "C:\Users\Clement\Desktop\Projet Économétrie 2"
insheet using "table_finale.csv", clear // Pour ouvrir un fichier .raw ou .csv


//cd "C:\Users\Clement\Desktop\Projet Économétrie 2\Données"
//use "indiv1990-2002.dta", clear // Pour ouvrir un fichier .raw ou .csv


//use "401k.dta" // Pour ouvrir un fichier classic stata
//drop origine_destination tuu_arrival tuu_departure seats_left heure_arrondie  duration depcom_departure depcom_arrival departure_latitude departure_longitude departure_day departure_dates departure_city_name arrival_city_name booking_mode arrival_latitude arrival_longitude
//regarder les données

describe //donne les variables et leur type 
summarize //Description quantitative : (aussi) su su
tabulate salmet  //  Description qualitative : aussi 
browse //Affichage de labase de données dans la console

//Rq : expérience potentielle = age-annee_etude-6 => exppo et année d'étude sont un peu liée mais l'âge les délie. ça revient à faire âge et année d'étude..
gen log_salmee = log(salmee)


//Reg naive en empilant tout et ne respectant rien

reg log_salmee c.exp_po c.exp_po#c.exp_po c.annee_etude
//une année d'étude augmente le salaire de 0.1 %
//l'exp potentielle joue à hauteur de Bex_p +2 B_exp^2, une année d'expérience potentielle  augment le salaire de 0.048 %







//gen log_price_per_dist=log(price_per_dist)
//gen log_decalage_depart=log(1+decalage_depart) //desfois le décalage dépar vaut 0..


//reg log_price_per_dist recommended_price vitesse_decalage nb_apparition_trajet nb_meme_trajet i.comfort_c i.coupleau_c i.tranche_horaire_c i.jour_semaine_c

* Within estimator
 //xtreg lcriv log_police unem incpc black y81-y93, fe
* With the cluster option fe pour fix effect
//faut-il un xt set avant ?

//intéraction variable1#variable2  //forcer  modalité de référence ? // Rq : lecture 8 de stata pour iterpréter les quali, on interprête le coeff comme l'écart d'impact sur le prix par rapport à la modalité de référence.
//xtset origine_destination_query_c permanent_id_c // i= origine-destination, t=trajet (cf cours, i = classe  t= élève) #réfléchir aux epsilons comme dans le cours ça fera des pazges  // question si je veux faire le trajet au cours du temps c'est chaud heureusement on l'évite en disant que le prix une fois fixé ne bouge plus.
//xtreg log_price_per_dist recommended_price vitesse_decalage_o_d nb_meme_trajet i.comfort_c i.coupleau_c i.tranche_horaire_c i.jour_semaine_c, fe cluster(origine_destination_query)

