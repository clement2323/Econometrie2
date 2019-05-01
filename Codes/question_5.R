rm(list=ls())
gc()
library(data.table)
library(foreign)
library(plyr)

df = fread('C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.csv')
df = df[!is.na(df$ddipl) & !is.na(df$salmee) & df$salmee >500 & !(df$salmee %in% c(9999998,9999999))]
df = df[df$annee >2007 & df$annee < 2010,]
dfa = aggregate(df$annee, by = df[,c('ident_ind')], length)
ind = dfa[dfa$x == 2,]$ident
ind
#on individus la en 2008 et 2009. On en a 185 environ
df = df[df$ident_ind %in% ind,]
df = df[,c('ident_ind', 'salmee', 'ddipl', 'exp_po')]

df2 = df[df$annee == 2009,c('annee','ddipl')]
df2$salmee_dif = log(df[df$annee == 2009,]$salmee) - log(df[df$annee == 2008,]$salmee)
df2$exp_po = df[df$annee == 2009,]$exp_po
df2$exp_po_dif = df[df$annee == 2009,]$exp_po - df[df$annee == 2008,]$exp_po
df2$salmee2 = log(df[df$annee == 2009,]$salmee)
df2$annee_etude = df[df$annee == 2009,]$annee_etude
a = df[df$annee == 2009,]$annee_etude - df[df$annee == 2008,]$annee_etude

write.dta(df2[,c('salmee2', 'salmee_dif', 'exp_po', 'annee_etude')], "C:/Users/Hugues/Desktop/Cours Ensae/econo/test_ex_str.dta")
