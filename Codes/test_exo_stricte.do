//******TD1*******//
clear all // Tout syupprimer, code et variables
drop _all // Effacer toutes les variables 

//ctrl + D pour executer ligne de commande sélectionnée

//cd "C:\Users\Clement\Desktop\Projet Économétrie 2"
cd "C:/Users/Hugues/Desktop/Cours Ensae/econo"
use "test_ex_str.dta", clear 

browse

// on n'inclut pas les différences d'expériences et d'annee d'études car 
// ces variables sont constantes. En revanche, on inclut les annees d'études
// et l'expérience potentielle de la deuxième année choisie
reg salmee_dif c.annee_etude c.exp_po

