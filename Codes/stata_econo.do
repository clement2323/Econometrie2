//******TD1*******//
clear all // Tout syupprimer, code et variables
drop _all // Effacer toutes les variables 

//ctrl + D pour executer ligne de commande sélectionnée
// Déclarer un répertoire de travail 

//PAR la suite, CREER UNE TABLE STATA POUR REP FACILEMENT A TOUTE§S LES QUESTIONSavec les libeelés en lieu et placce des codes pour plus de facilité dans l'interprétation
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

//Dans toute la suite, on fera fit du fait que les valeurs manquantes pour la variable explicative sont forcément liées aux valeurs de ces dernières
// faire peut etre une stat pour voir que les plus diplomés sont les plus riches et aussi ceux qui repondent le moins souvent ?



//Reg naive en empilant tout et ne respectant rien
//Q 4
reg log_salmee c.exp_po c.exp_po#c.exp_po c.annee_etude
//une année d'étude augmente le salaire de 0.1 %
//l'exp potentielle joue à hauteur de Bex_p +2 B_exp^2, une année d'expérience potentielle augmente le salaire de 0.048 %
// sans biais si les variables explicatives sont exogènes au bruit et ?? à revoir
// si les variables sont exogènes au bruit ie si  (les XI iid sont nécessaires pour la convergence de la moyenne en espérance).
// les obs ne sont pas iid car les individus sont interrogés plusieurs fois donc lien entre les différentes interrogations
// + les logement sinterrogés sont dans la même grappe etc..

//Question 5 
// plusieurs cas : prenons pour i= individu et t trimestre de l'année  Y_it=x_ibeta +alphai+eppsit avec alphai l'effet individuel
// si E(Xialphai)=0 => pas d'endogénéité (effets aléatoires) le seul problème se situe au niveau des estimateurs de variance non convergents (ça se regle avec l'option cluster)

// Si E(Xitalphai)!=0 ce qui est certainement le cas puisque l'effet individuel de i joue certainement sur son niveau de diplôme
//Tester within and first diff et développer leurs avantages et inconvénients, le pb de first diff c'est qu'on perd une obsevation et on en a pas toujour 2 interrogation
// le within est plus économique, à voir ce qui se passe en essayant les deux. (je reprends les codes du cours d'économétrie).
// À ce propose faut-il vraiment estimer le modèle ? ce n'est pas demandé.
// pour que within marche il faut exogénéité stricte,ie E(xit*epsit')=0 quelquesoit t et t'
//ie Xit non corrélé aux chocs passés et futurs, on y croit pas trop,par exemple le salaire future va dépendre du salaie passé, dernière solution => exo faible et instrumentalisation  mais chiant.

//Question 6
// je vais remplir la variable salmet sur R quand salmee(salaire en euro est rempli) puis faire un polytomique ? var explicative ?
//Rq : dans le cours chapitre 4 on a déjà le code, le prof pose rgi ==1 pour fixer le rang d'interrogation de lindiv à 1 ie à sa première interrogation (il y en a 6 au total) certaines ariables ne sont dspo que pour certains rangs.
//Il ne faut pas oublier de filtrer les 15 65 ans aussi !

gen borne_inf = log(500)*(salmet=="B")+log(1000)*(salmet=="C")+log(1250)*(salmet=="D")+log(1500)*(salmet=="E")+log(2000)*(salmet=="F")+log(2500)*(salmet=="G")+log(3000)*(salmet=="H")+log(5000)*(salmet=="I")+log(8000) * (salmet == "J") if salmet !="A" & salmet!="98" & salmet !=""

gen borne_sup = log(500)*(salmet=="A")+log(1000)*(salmet=="B")+log(1250)*(salmet=="C")+log(1500)*(salmet=="D")+log(2000)*(salmet=="E")+log(2500)*(salmet=="F")+log(3000)*(salmet=="G")+log(5000)*(salmet=="H")+log(8000) * (salmet == "I") if salmet !="J" & salmet!="98" & salmet !=""
//en faisant
char ddipl[omit] 7 
// on impose que la oda de référence soit le 7 sans diplôme
gen femme = (sexe ==2)

xi : intreg borne_inf borne_sup c.exp_po c.exp_po#c.exp_po femme i.ddipl
		
tabulate ddipl // ddipl1 c'est le diplome du sup
//Comme dans le cours on pourrait faire un modèle polytomique ordonné sans seuil connus pour vérifier 

//le signe des coeffs est interprétable et le rapport des coeffs entre eux aussi, par cntre linterprétation de X dichotomque est à écrire.
//comment interpréter le coeff de femme ? demander à hugues ou david ? //le probit avec seuil inconnus estimera 9 seuils car en fixera un à 0.
//regarder les Td pour l'interprétaztion des coeffs on peut certainement interpréter les rapport de coeff et le signe des coeffs.
// sinon revenir au modèle 0 1 en regardant P(Y<k) plutot que P(y=k) et dériver.

//essayer les effets marginaux à la moyenne et l'effer marginal moyen car sinon l'effet marginal dépend du vecteur xi
//Rq : faire apparaitre des variables de controles permet de dégager de l'endogénéité du bruit. Une variable est rarement totalement endogène mais on ne peut pas toutes les instrumenter non plus..



//Question 6 la variable par tranche est en fait un second best quand on a pas l'info sur le salaire..
// but recoder les salmee en tranche et faire du polytomique ordonné, pourquoi un ou plusieurs modèles ..??
//on néglige le côté panel ici, ok c'est beaucoup plus simple. Pour l'instant, pas d'idée du deuxième modèle.


//PARTIE 3 à l'échelle de la ville






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

