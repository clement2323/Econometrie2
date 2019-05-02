//******TD1*******//
clear all // Tout syupprimer, code et variables
drop _all // Effacer toutes les variables 

//ctrl + D pour executer ligne de commande sélectionnée

//cd "C:\Users\Clement\Desktop\Projet Économétrie 2"
cd "C:/Users/Hugues/Desktop/Cours Ensae/econo"
insheet using "table_finale.csv", clear // Pour ouvrir un fichier .raw ou .csv

//cd "C:\Users\Clement\Desktop\Projet Économétrie 2\Données"
//use "indiv1990-2002.dta", clear // Pour ouvrir un fichier .raw ou .csv

describe //donne les variables et leur type 
summarize //Description quantitative : (aussi) su su
tabulate salmet  //  Description qualitative : aussi 
browse //Affichage de labase de données dans la console

//choix de variables
//keep 


//Rq : expérience potentielle = age-annee_etude-6 => exppo et année d'étude sont un peu liée mais l'âge les délie. ça revient à faire âge et année d'étude..
gen log_salmee = log(salmee)
gen log_salmee_actu = log(salmee_actu)
gen femme = (sexe == 2)
//Dans toute la suite, on fera fit du fait que les valeurs manquantes pour la variable explicative sont forcément liées aux valeurs de ces dernières
// faire peut etre une stat pour voir que les plus diplomés sont les plus riches et aussi ceux qui repondent le moins souvent ?

//Reg naive en empilant tout et ne respectant rien
//Q 4
reg log_salmee c.exp_po c.exp_po#c.exp_po c.annee_etude //c.femme
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

gen borne_inf_actu = log(500)*(salmet_actu=="B")+log(1000)*(salmet_actu=="C")+log(1250)*(salmet_actu=="D")+log(1500)*(salmet_actu=="E")+log(2000)*(salmet_actu=="F")+log(2500)*(salmet_actu=="G")+log(3000)*(salmet_actu=="H")+log(5000)*(salmet_actu=="I")+log(8000) * (salmet_actu == "J") if salmet_actu !="A" & salmet_actu!="98" & salmet_actu !=""

gen borne_sup_actu = log(500)*(salmet_actu=="A")+log(1000)*(salmet_actu=="B")+log(1250)*(salmet_actu=="C")+log(1500)*(salmet_actu=="D")+log(2000)*(salmet_actu=="E")+log(2500)*(salmet_actu=="F")+log(3000)*(salmet_actu=="G")+log(5000)*(salmet_actu=="H")+log(8000) * (salmet_actu == "I") if salmet_actu !="J" & salmet_actu!="98" & salmet_actu !=""

char ddipl[omit] 7 
// on impose que la oda de référence soit le 7 sans diplôme

xi : intreg borne_inf borne_sup c.exp_po c.exp_po#c.exp_po femme i.ddipl

xi : intreg borne_inf_actu borne_sup_actu c.exp_po c.exp_po#c.exp_po femme i.ddipl
		
tabulate ddipl // ddipl1 c'est le diplome du sup
//Comme dans le cours on pourrait faire un modèle polytomique ordonné sans seuil connus pour vérifier 

//le signe des coeffs est interprétable et le rapport des coeffs entre eux aussi, par cntre linterprétation de X dichotomque est à écrire.
//comment interpréter le coeff de femme ? demander à hugues ou david ? //le probit avec seuil inconnus estimera 9 seuils car en fixera un à 0.
//regarder les Td pour l'interprétaztion des coeffs on peut certainement interpréter les rapport de coeff et le signe des coeffs.
// sinon revenir au modèle 0 1 en regardant P(Y<k) plutot que P(y=k) et dériver.
// ce n'est pas un logit..

// Hello Clément, on peut interpréter les coefs quantitativement normalement !!


//essayer les effets marginaux à la moyenne et l'effer marginal moyen car sinon l'effet marginal dépend du vecteur xi
//Rq : faire apparaitre des variables de controles permet de dégager de l'endogénéité du bruit. Une variable est rarement totalement endogène mais on ne peut pas toutes les instrumenter non plus..



//Question 6 la variable par tranche est en fait un second best quand on a pas l'info sur le salaire..
// but recoder les salmee en tranche et faire du polytomique ordonné, pourquoi un ou plusieurs modèles ..??
//on néglige le côté panel ici, ok c'est beaucoup plus simple. Pour l'instant, pas d'idée du deuxième modèle.


//PARTIE 3 à l'échelle de la ville

//Question 7
//cser cspp ag nbagenf
//type men ?
gen salrep = (salmee !=. )
//il y a 136 000 individus qui donnent leurs salaires seulement
egen sit_ind_c=group(sit_ind)
tabulate sit_ind sit_ind_c

//i.nbagenf  ne donne pas grand chose la variable typ men est plus agrégée on risque de voir plus d'effets dedans
reg log_salmee i.sit_ind_c taux_dip_dep femme immigre i.typmen c.ag c.ag#c.ag ret6m //tx_chomage esp_vie pas significatives (sauf à 20 % pour esp_vie) 
//l'effet de l'âge sur le diplôme est positif mais diminue l'âge augmente quand ce dernier augmente normal, yes?
//le bac est la modalité de référence ici on voit que le gradient de salaire suit celui du diplôme
// le nbagenfant est croissant avec le nombre d'enfant, peu d'effet sur salaire et le fait d'avoir des enfants semble jouer possitivement sur le salaire..
//le fait d'être immigré joue négativement sur le salaire, à diplôme égal..
// tout le monde est mieux rémunéré que le ménage à une personne..on fait pas d'enfant quand on a rien ? je me serai attendu à une idée de sacrifice des études du fait d'avoir des enfants
//peut être faut il faire intéragir femme et type ménage pour voir un effet négatif.

reg log_salmee i.sit_ind_c taux_dip_dep femme i.typmen femme#i.typmen immigre c.ag c.ag#c.ag i.cspp ret6m
//Question je n'ai pas mis la variable cser ici (csp de l'enquêtée) car elle est directement reliée au salaire, totologique si la csp du mec bouge alors c'est qu'il avait des aptitudes lemploi occupé explique le salaire?
//la csp non renseignée 0 est celle qui donne les effets les plus positifs sur le salaire, dur à interpréter
// effet du taux de chomage sur le ssalaire positif ?? très bizarre (effet très faible)

//tabulate(cspp)
//boum là on voit que les femmes avec enfant prennent des malus au niveau du salaire, c'est l'intéracton qui craint, un homme avec enfant ça change pas grand chose.




// VI : 
// tests condition de rang :

// pour diplome global
gen etab_sum = institut_universitaire_de_techno + institut_universitaire_professio + universit + composante_universitaire
correlate taux_dip_dep ret6m tx_chomage esp_vie 
correlate taux_dip_dep etab_sum institut_universitaire_de_techno institut_universitaire_professio universit composante_universitaire
// esp_vie semble le meilleur instrument pour taux_dip_dep (correlation à 0.52), vient ensuite composante_universitaire puis etab_sum (corr de 0.45)
// on va pouvoir tester notre modèle, et en plus très bien parce que ces variables sont pas dans notre modèle.

// On fait des 2MC tout d'abord
ivregress 2sls log_salmee i.sit_ind_c femme i.typmen femme#i.typmen immigre c.ag c.ag#c.ag i.cspp ret6m (taux_dip_dep = esp_vie), first
ivregress 2sls log_salmee i.sit_ind_c femme i.typmen femme#i.typmen immigre c.ag c.ag#c.ag i.cspp ret6m (taux_dip_dep = etab_sum), first
// On obtient sensiblement même chose que tout à l'heure en plus faible mais intervalle confiance plus étendu.


// Pb : comment on fait différences premières avec nos données ???
// gen log_salmee_1stdif = 


// pour diplome individuel
correlate annee_etude naim cspp cspm
// mois naissance = instrument très très faible, 
// on peut penser à ANCCHOMM (temps au chômage en mois), CSTOTR et CSP, ASSOCI (prend part aux décisions), CONGJ/CONGJR selon l'annee (nombre jours congé), 
// CSTOTPRMCJ ou CSTOTCJ selon annee(études du conjoint de la personne de référence du ménage --> personne interrogée ??)





//Question 9

//Question sur les données de panel
//dans un premier temps avec xtsetj'indique ce qu'est le temps (ident_temps) et ce qu'est l'indiv(ident_ind)	
egen ident_ind_c=group(ident_ind)
egen ident_temps_c=group(ident_temps)
xtset ident_ind_c ident_temps_c
//Question, sens des différences premières avec des variables quali  peut-être faut -il faire la différene première de toutes le indicatrices ?
foreach x of varlist log_salmee sit_ind_c taux_dip_dep taux_chom femme typmen  immigre ag  cspp {
 gen d_`x'=d.`x'
}
tabulate(sit_ind_c)
reg d_log_salmee d_sit_ind_c d_taux_dip_dep d_taux_chom d_femme d_typmen d_immigre d_ag d_cspp









//intéraction variable1#variable2  //forcer  modalité de référence ? // Rq : lecture 8 de stata pour iterpréter les quali, on interprête le coeff comme l'écart d'impact sur le prix par rapport à la modalité de référence.
//xtset origine_destination_query_c permanent_id_c // i= origine-destination, t=trajet (cf cours, i = classe  t= élève) #réfléchir aux epsilons comme dans le cours ça fera des pazges  // question si je veux faire le trajet au cours du temps c'est chaud heureusement on l'évite en disant que le prix une fois fixé ne bouge plus.
//xtreg log_price_per_dist recommended_price vitesse_decalage_o_d nb_meme_trajet i.comfort_c i.coupleau_c i.tranche_horaire_c i.jour_semaine_c, fe cluster(origine_destination_query)

