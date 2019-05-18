clear all 
drop _all 

. ssc install estout


cd "C:\Users\Clement\Desktop\Projet Économétrie 2"
insheet using "table_finale.csv", clear 
//use "indiv1990-2002.dta", clear // Pour ouvrir un fichier .raw ou .csv

describe //donne les variables et leur type 
summarize salmee //Description quantitative : (aussi) su su
tabulate salmet  //  Description qualitative : aussi 
browse //Affichage de labase de données dans la console



drop log_salmee
gen log_salmee = log(salmee)
drop log_salhor
gen log_salhor = log(salhor)
gen femme = (sexe == 2)

//arrondit de la variable poids
gen poids = round(extri*1000, 1)

//Q 4 //Premier modèle "naif"
eststo clear
eststo : reg log_salmee c.exp_po c.exp_po#c.exp_po c.annee_etude femme [fweight = poids]
//esttab using "W:/table_2.tex", se ar2


//Q5
// test d'exogénéîté 

//définition de i et t
egen ident_ind_2 =group(ident_ind)
xtset ident_ind_2 annee 

 gen d_log_salmee=d.log_salmee
 gen d_exp_po =d.exp_po 
 gen exp_po_carre=c.exp_po*c.exp_po 
 gen d_exp_po_carre =d.exp_po_carre 

 //annee_etude ne bouge pas en théorie il ne reste plus que l'expérience potentielle, je la rajoute dans le modèle sans la différencier
 //sous exogénéité, son coefficient estimé devrait être non significatif
 reg d_log_salmee d_exp_po d_exp_po_carre exp_po [fweight = poids], nocons 
// on trouve que le coefficient devant exp_po est significatif à--> l'exogénéité stricte est rejetée




//Q6
//génération des bornes
gen borne_inf = log(500)*(salmet=="B")+log(1000)*(salmet=="C")+log(1250)*(salmet=="D")+log(1500)*(salmet=="E")+log(2000)*(salmet=="F")+log(2500)*(salmet=="G")+log(3000)*(salmet=="H")+log(5000)*(salmet=="I")+log(8000) * (salmet == "J") if salmet !="A" & salmet!="98" & salmet !=""
gen borne_sup = log(500)*(salmet=="A")+log(1000)*(salmet=="B")+log(1250)*(salmet=="C")+log(1500)*(salmet=="D")+log(2000)*(salmet=="E")+log(2500)*(salmet=="F")+log(3000)*(salmet=="G")+log(5000)*(salmet=="H")+log(8000) * (salmet == "I") if salmet !="J" & salmet!="98" & salmet !=""

//en faisant
char ddipl[omit] 7 
// on impose que la oda de référence soit le 7 sans diplôme
xi : intreg borne_inf borne_sup c.exp_po c.exp_po#c.exp_po femme i.ddipl [fweight = poids]
tabulate ddipl // ddipl1 c'est le diplome du sup



//Q7 estimation du modèle sans instrumentation
encode sit_ind , gen(sit_ind_c)
tabulate sit_ind sit_ind_c
//Régression sans prendre en compte l'hétérogénéité inobservée
char sit_ind_c[omit] 6 

// variables niveau individu , sexe, immigre, age, typmenage sousempl 
//Variables niveau départementXannee taux de chomage et population active. (calculés à parir de la base)
//création d'une variable indicatrice de non sous emploi

gen no_sousempl=(sousempl != 1)& (sousempl != 2) & (sousempl != 3)
tabulate no_sousempl
reg log_salmee i.sit_ind_c taux_dip_dep i.no_sousempl femme immigre i.typmen c.ag c.ag#c.ag pop_dep_annee tx_chomage[fweight = poids]


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

//et on test ces 2 instruments ainsi que celui qui donne la création d'établissement entre 4 à 6 ans auparavant

ivreg  d_log_salmee d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage (d_taux_dip_dep= lag_taux_dip_dep) [fweight = poids], first robust
//ivreg  d_log_salmee d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage (d_taux_dip_dep= d_lag_taux_dip_dep),first robust pas assez d'oservation pour faire le lag de taux dip dep
ivreg  d_log_salmee d_tx_dep_annee_indu d_tx_dep_annee_terti d_tx_chomage (d_taux_dip_dep= crea_4_6_dernieres) [fweight = poids],first robust
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

//ça marche séparément
xi : ivreg log_salmee i.no_sousempl femme i.immigre i.typmen ag2 ag_carre pop_dep_annee tx_chomage ( taux_dip_dep=tx_dep_annee_indu) [fweight = poids],first robust 
xi : ivreg log_salmee i.no_sousempl femme i.immigre i.typmen ag2 ag_carre pop_dep_annee tx_chomage ( i.sit_ind_c=i.cspp) [fweight = poids],first robust 

reg3 (log_salmee taux_dip_dep i.sit_ind_c i.no_sousempl femme i.immigre i.typmen ag2 ag_carre pop_dep_annee tx_chomage) (taux_dip_dep tx_dep_annee_indu) (i.sit_ind_c i.cspp), 3sls

reg log_salmee femme i.typmen i.typmen#femme immigre c.ag c.ag#c.ag i.cspp tx_dep_annee_terti tx_dep_annee_indu tx_chomage [fweight = poids],first robust 

ivregress 2sls y x1 (x2 x5 =x3 x4 x6 x7)


