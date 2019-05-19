clear all 
drop _all 

//. ssc install estout


//cd "C:\Users\Clement\Desktop\Projet Économétrie 2"
cd "C:\Users\Hugues\Desktop\Cours Ensae\econo"
insheet using "table_finale.csv", clear 
//use "indiv1990-2002.dta", clear // Pour ouvrir un fichier .raw ou .csv

describe //donne les variables et leur type 
summarize salmee //Description quantitative : (aussi) su su
tabulate salmet  //  Description qualitative : aussi 
browse //Affichage de labase de données dans la console


drop log_salmee
gen log_salmee = log(salmee)
gen femme = (sexe == 2)
keep if salmee <= 120000
//arrondit de la variable poids
gen poids = round(extri*1000, 1)
gen indicatrice2009 = (annee >= 2009)
//Q 4 //Premier modèle "naif"
encode sit_ind , gen(sit_ind_c)
tabulate sit_ind sit_ind_c
eststo clear
char sit_ind_c[omit] 6
eststo : reg log_salmee c.exp_po c.exp_po#c.exp_po femme c.annee_etude [fweight = poids]
eststo : xi : reg log_salmee c.exp_po c.exp_po#c.exp_po femme i.sit_ind_c [fweight = poids]
eststo : xi : reg log_salmee c.exp_po c.exp_po#c.exp_po femme i.sit_ind_c indicatrice2009 [fweight = poids]
esttab using "C:/Users/Hugues/Desktop/que2.tex", se r2 ar2
//esttab using "W:/table_2.tex", se ar2


//Q5
// test d'exogénéîté 

//définition de i et t
egen ident_ind_2 =group(ident_ind)
//il y a des duplicatas dans les années 2013 et 2014. On a besoin de les enlever :
duplicates list ident_ind_2 annee //permet de voir quelles observations posent problème
duplicates tag ident_ind_2 annee, gen(isdup) // on les marque 
keep if isdup == 0 // et on les supprime : 76 observartions supprimées
xtset ident_ind_2 annee 

gen d_log_salmee=d.log_salmee
gen d_exp_po =d.exp_po 
gen exp_po_carre=c.exp_po*c.exp_po 
gen d_exp_po_carre =d.exp_po_carre 

 //annee_etude ne bouge pas en théorie il ne reste plus que l'expérience potentielle, je la rajoute dans le modèle sans la différencier
 //sous exogénéité, son coefficient estimé devrait être non significatif
 eststo clear
reg d_log_salmee d_exp_po d_exp_po_carre exp_po [fweight = poids], nocons 
esttab using "C:/Users/Hugues/Desktop/que5.tex", se r2 ar2
// on trouve que le coefficient devant exp_po est significatif à--> l'exogénéité stricte est rejetée




//Q6
//génération des bornes
gen borne_inf = log(500)*(salmet=="B")+log(1000)*(salmet=="C")+log(1250)*(salmet=="D")+log(1500)*(salmet=="E")+log(2000)*(salmet=="F")+log(2500)*(salmet=="G")+log(3000)*(salmet=="H")+log(5000)*(salmet=="I")+log(8000) * (salmet == "J") if salmet !="A" & salmet!="98" & salmet !=""
gen borne_sup = log(500)*(salmet=="A")+log(1000)*(salmet=="B")+log(1250)*(salmet=="C")+log(1500)*(salmet=="D")+log(2000)*(salmet=="E")+log(2500)*(salmet=="F")+log(3000)*(salmet=="G")+log(5000)*(salmet=="H")+log(8000) * (salmet == "I") if salmet !="J" & salmet!="98" & salmet !=""



eststo clear
* Model 1
//en faisant
char sit_ind_c[omit] 6
// on impose que la oda de référence soit le 7 sans diplôme
//xi : intreg borne_inf borne_sup c.exp_po c.exp_po#c.exp_po femme i.ddipl [fweight = poids]
eststo: xi : intreg borne_inf borne_sup c.exp_po c.exp_po#c.exp_po c.annee_etude [fweight = poids]
* Model 2
eststo: xi : intreg borne_inf borne_sup c.exp_po c.exp_po#c.exp_po i.sit_ind_c [fweight = poids]
* Model 3
eststo: xi : intreg borne_inf borne_sup c.exp_po c.exp_po#c.exp_po femme i.sit_ind_c [fweight = poids]

esttab
// adding R^2 and adj. R^2
esttab , r2 ar2
esttab using "C:/Users/Hugues/Desktop/qu6_finale.tex", se r2 ar2

//en faisant
char ddipl[omit] 7 
// on impose que la oda de référence soit le 7 sans diplôme
xi : intreg borne_inf borne_sup c.exp_po c.exp_po#c.exp_po femme i.ddipl [fweight = poids]
tabulate ddipl // ddipl1 c'est le diplome du sup



//Q7 estimation du modèle sans instrumentation

//Régression sans prendre en compte l'hétérogénéité inobservée
char sit_ind_c[omit] 6 

// variables niveau individu , sexe, immigre, age, typmenage sousempl 
//Variables niveau départementXannee taux de chomage et population active. (calculés à parir de la base)
//création d'une variable indicatrice de non sous emploi

gen no_sousempl=(sousempl != 1)& (sousempl != 2) & (sousempl != 3)
tabulate no_sousempl
char sit_ind_c[omit] 6 
eststo clear
eststo: xi : reg log_salmee i.sit_ind_c taux_dip_dep i.no_sousempl femme immigre i.typmen c.ag c.ag#c.ag pop_dep_annee tx_chomage[fweight = poids]
eststo: xi : reg log_salmee c.annee_etude taux_dip_dep i.no_sousempl femme immigre i.typmen c.ag c.ag#c.ag pop_dep_annee tx_chomage[fweight = poids]
esttab using "C:/Users/Hugues/Desktop/qu7_fin.tex", se r2 ar2

//Q9 je vais générer les variables en first diff  // avec la même définition de i et t qu'en question 5

//création des diffs premières pour les variables qui bougent en différenciant une fois (on suppose que le diplome individuel ne bougera pas)
foreach x of varlist taux_dip_dep tx_dep_annee_constru tx_dep_annee_indu tx_dep_annee_terti tx_chomage {
gen d_`x'=d.`x'
}

//sans instrument (la constante s'en va en différenciant)
reg d_log_salmee d_taux_dip_dep d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage [fweight = poids],  nocons 

// maintenant, instrumentons par lag(taux_dip_dep) ou Delta(lag(taux_dip_dep) comme vu en cours
by ident_ind_2: gen lag_taux_dip_dep =taux_dip_dep[_n-1]
gen d_lag_taux_dip_dep=d.lag_taux_dip_dep



eststo clear
reg d_taux_dip_dep d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage lag_taux_dip_dep crea_4_6_dernieres crea_5_10_dernieres
eststo
ivregress 2sls d_log_salmee d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage (d_taux_dip_dep= lag_taux_dip_dep crea_4_6_dernieres crea_5_10_dernieres) [fweight = poids], first robust nocons
eststo
esttab using "C:/Users/Hugues/Desktop/youpi2.tex", mtitles("First Stage" "Second Stage")



//et on test ces 2 instruments ainsi que celui qui donne la création d'établissement entre 4 à 6 ans auparavant
eststo clear
eststo : ivregress 2sls d_log_salmee d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage (d_taux_dip_dep= lag_taux_dip_dep crea_4_6_dernieres crea_5_10_dernieres) [fweight = poids], first robust nocons
esttab using "C:/Users/Hugues/Desktop/youpi.tex", se r2 ar2

//ivreg  d_log_salmee d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage (d_taux_dip_dep= d_lag_taux_dip_dep),first robust pas assez d'oservation pour faire le lag de taux dip dep
ivreg  d_log_salmee d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage (d_taux_dip_dep= crea_4_6_dernieres) [fweight = poids],first robust nocons
ivreg  d_log_salmee d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage (d_taux_dip_dep= crea_5_10_dernieres) [fweight = poids],first robust //effet négatif 

// création d'établissement d'enseignement du supérieur seulement pour le taux de diplomé du sup 
ivreg d_log_salmee d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage (d_taux_dip_dep= crea_4_6_dernieres_sup) [fweight = poids],first robust
ivreg d_log_salmee d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage (d_taux_dip_dep= crea_5_10_dernieres_sup) [fweight = poids],first robust


//Q10
//on va instrumenter à la fois le taux de diplomé dans le département pour l'année considérée et le niveau de diplome de l'individu considéré.
//Toutefois cette fois ci c'est le taux de diplomés du département en niveau qu'on veut instrumenter et non son évolution->
//pour le niveau de diplôme on peut prendre le trimestre de naissance de l'individu (exemple classique) mais aussi la csp du père et de la mère


//on reprend donc le modèle de la question 7 en instrumentant cette fois ci les 2 variables pertinentes pour avoir le spill over et le rendement privé (on remet la constante)
egen cspp_c =group(cspp)
gen ag_carre = c.ag*c.ag
gen ag2=c.ag

correlate sit_ind_c cspp cspm
correlate annee_etude cspp cspm
//ça marche séparément
ivregress 2sls log_salmee i.no_sousempl femme i.immigre i.typmen ag2 ag_carre pop_dep_annee tx_chomage ( taux_dip_dep=tx_dep_annee_indu) [fweight = poids],first robust 
ivregress 2sls log_salmee i.no_sousempl femme i.immigre i.typmen ag2 ag_carre pop_dep_annee tx_chomage ( i.sit_ind_c=i.cspp) [fweight = poids],first robust 

reg3 (log_salmee i.no_sousempl femme i.immigre i.typmen ag2 ag_carre pop_dep_annee tx_chomage taux_dip_dep i.sit_ind_c) (taux_dip_dep = tx_dep_annee_indu) (sit_ind_c = i.cspp) [fweight = poids], 3sls

eststo clear
eststo xi : reg3 (log_salmee taux_dip_dep c.annee_etude i.no_sousempl femme i.immigre i.typmen ag2 ag_carre pop_dep_annee tx_chomage) (taux_dip_dep tx_dep_annee_indu) (annee_etude i.cspp) [fweight = poids], 3sls
esttab using "C:/Users/Hugues/Desktop/ah2.tex", labcol2(+ - +/- + 0)



reg log_salmee femme i.typmen i.typmen#femme immigre c.ag c.ag#c.ag i.cspp tx_dep_annee_terti tx_dep_annee_indu tx_chomage [fweight = poids],first robust 

ivregress 2sls y x1 (x2 x5 =x3 x4 x6 x7)


