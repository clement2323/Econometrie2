rm(list=ls())
gc()
library(data.table)
library(foreign)
library(plyr)

#IDEE POUR LA PARTIE REG : CREEER UNE TABLE CSV AVEC LES VRAIS LIBELLES A LAPLACE DES CODES POUR PAS GALERER


############################
####### Question 4 #########
# data frame de base
df = fread('C:/Users/Hugues/Desktop/Cours Ensae/econo/table_finale.csv')
nrow(df) # 411 148

# sans les na
df_train = df[!is.na(df$ddipl) & !is.na(df$salmee) & df$salmee >100 & df$salmee < 999998]
nrow(df_train) # 122 832

# modele question 4
model = lm(log(salmee) ~ annee_etude + poly(exp_po, 2, raw = TRUE), data = df_train)
summary(model)



# valeurs qu'on veut predire
df_na = df[!is.na(df$ddipl) & (is.na(df$salmee) | df$salmee < 100)]
nrow(df_a_pred) # 288 462

#hist(df_train$salmee, breaks = 1000, xlim = c(0,2700))
# on trouve relativement peu de petites et grandes valeurs
# car le modele entraine majoritairement sur valeurs moyennes
salmee_pred = exp(predict(model, newdata = df_na))
summary(salmee_pred)
hist(salmee_pred,breaks = 100)






############################
####### Question 6 #########

df_tranche = df[which(df$salmet != ""),]
nrow(df_tranche) #26 601

df_tranche$salmet = revalue(as.factor(df_tranche$salmet), 
        c("1"="A", "2"="B", "3"="C","4"="D","5"="E","6"="F","7"="G",
          "8"="H","9"="I","10"="J","98"="99"))
df_tranche$salmet







