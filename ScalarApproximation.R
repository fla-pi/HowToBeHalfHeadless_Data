library(dplyr)
library(partykit) 
library(forcats)
library(caret)
library(forcats)
library(tidyr)
library(janitor)
library(knitr)
library(kableExtra)
library(stats)
library(tibble)

dataset <- read.csv(file.choose(), sep = ";")

# Funzione per calcolare test chi-quadro con simulazione e residui standardizzati
get_chisq_residuals <- function(tbl) {
  test <- chisq.test(tbl, simulate.p.value = TRUE, B = 2000)
  residuals <- residuals(test)
  list(test = test, residuals = residuals)
}

# Funzione per creare tabella contingenza con counts e unique types
contingency_tables <- function(data) {
  # Tabella con conteggi grezzi
  tab_freq <- table(data$ScalePoint_Base, data$Approximation_Output)
  
  # Tabella con counts di unique Lemma_Base per cella
  tab_unique_types <- data %>%
    distinct(ScalePoint_Base, Approximation_Output, Lemma_Base) %>%
    count(ScalePoint_Base, Approximation_Output) %>%
    pivot_wider(names_from = Approximation_Output, values_from = n, values_fill = 0) %>%
    column_to_rownames("ScalePoint_Base")
  
  # Calcolo test chi-quadro e residui
  result_freq <- get_chisq_residuals(tab_freq)
  result_unique <- get_chisq_residuals(as.matrix(tab_unique_types))
  
  list(
    freq = list(table = tab_freq, test = result_freq$test, residuals = result_freq$residuals),
    unique = list(table = tab_unique_types, test = result_unique$test, residuals = result_unique$residuals)
  )
}


complete_results <- contingency_tables(dataset)


semi_data <- filter(dataset, Cxn == "semi")
mezzo_data <- filter(dataset, Cxn == "mezzo")

semi_results <- contingency_tables(semi_data)
mezzo_results <- contingency_tables(mezzo_data)


######################## CIT #########################

dataset$Approximation_Output <- as.factor(dataset$Approximation_Output)
dataset$ScalePoint_Base <- as.factor(dataset$ScalePoint_Base)
dataset$Cxn <- as.factor(dataset$Cxn)

dataset$Approximation_Output <- fct_recode(
  dataset$Approximation_Output,
  Att = "Attenuation",
  Mit = "Mitigation/Downtoner",
  Sim = "Similarity",
  KinC = "KinCategorization",
  Prox = "Proximative",
  Fake = "Fakeness"
)

mod <- partykit::ctree(Approximation_Output ~ ScalePoint_Base + Cxn, data = dataset)


'''
Model formula:
Approximation_Output ~ ScalePoint_Base + Cxn

Fitted party:
[1] root
|   [2] ScalePoint_Base in maximum_standard
|   |   [3] Cxn in mezzo: Prox (n = 170, err = 30.6%)
|   |   [4] Cxn in semi: Prox (n = 144, err = 27.1%)
|   [5] ScalePoint_Base in mimimum_standard, non-scalar, relative_position
|   |   [6] ScalePoint_Base in mimimum_standard
|   |   |   [7] Cxn in mezzo: Att (n = 94, err = 35.1%)
|   |   |   [8] Cxn in semi: Att (n = 52, err = 19.2%)
|   |   [9] ScalePoint_Base in non-scalar, relative_position
|   |   |   [10] Cxn in mezzo: Att (n = 36, err = 47.2%)
|   |   |   [11] Cxn in semi: KinC (n = 104, err = 47.1%)

Number of inner nodes:    5
Number of terminal nodes: 6

'''

confusionMatrix(table(predict(mod), dataset$Approximation_Output))

'''
Confusion Matrix and Statistics

      
       Att Fake KinC Mit Prox Sim
  Att  122    1    0  42   13   4
  Fake   0    0    0   0    0   0
  KinC  18    0   55   2   21   8
  Mit    0    0    0   0    0   0
  Prox  46    0    9  36  223   0
  Sim    0    0    0   0    0   0

Overall Statistics
                                          
               Accuracy : 0.6667          
                 95% CI : (0.6274, 0.7043)
    No Information Rate : 0.4283          
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.4975          
                                          
 Mcnemars Test P-Value : NA              

Statistics by Class:
  
  Class: Att Class: Fake Class: KinC Class: Mit Class: Prox Class: Sim
Sensitivity              0.6559    0.000000     0.85938     0.0000      0.8677       0.00
Specificity              0.8551    1.000000     0.90858     1.0000      0.7347       1.00
Pos Pred Value           0.6703         NaN     0.52885        NaN      0.7102        NaN
Neg Pred Value           0.8469    0.998333     0.98185     0.8667      0.8811       0.98
Prevalence               0.3100    0.001667     0.10667     0.1333      0.4283       0.02
Detection Rate           0.2033    0.000000     0.09167     0.0000      0.3717       0.00
Detection Prevalence     0.3033    0.000000     0.17333     0.0000      0.5233       0.00
Balanced Accuracy        0.7555    0.500000     0.88398     0.5000      0.8012       0.50
'''

varimp <- varimp(mod, conitional = TRUE)

'''
ScalePoint_Base             Cxn 
      1.3068032       0.8097854
'''

dotchart(sort(varimp), xlab = "Conditional variable importance")
abline(v = abs(min(varimp)),lty = 2, lwd = 2, col = "red")


############### Types ########################



get_unique_long_with_cxn <- function(data) {
         data %>%
         distinct(ScalePoint_Base, Approximation_Output, Lemma_Base, Cxn) %>%
         arrange(ScalePoint_Base, Approximation_Output, Cxn, Lemma_Base)
     }
 

unique_long_df <- get_unique_long_with_cxn(dataset)

ctree_model <- ctree(Approximation_Output ~ ScalePoint_Base + Cxn, data = unique_long_df)

  
'''

Model formula:
  Approximation_Output ~ ScalePoint_Base + Cxn

Fitted party:
  [1] root
|   [2] ScalePoint_Base in maximum_standard
|   |   [3] Cxn in mezzo: Prox (n = 53, err = 45.3%)
|   |   [4] Cxn in semi: Prox (n = 50, err = 34.0%)
|   [5] ScalePoint_Base in mimimum_standard, non-scalar, relative_position
|   |   [6] Cxn in mezzo
|   |   |   [7] ScalePoint_Base in mimimum_standard: Att (n = 59, err = 39.0%)
|   |   |   [8] ScalePoint_Base in non-scalar, relative_position: Att (n = 33, err = 45.5%)
|   |   [9] Cxn in semi
|   |   |   [10] ScalePoint_Base in mimimum_standard: Att (n = 19, err = 31.6%)
|   |   |   [11] ScalePoint_Base in non-scalar, relative_position: KinC (n = 70, err = 64.3%)

Number of inner nodes:    5
Number of terminal nodes: 6
'''

confusionMatrix(table(predict(ctree_model), unique_long_df$Approximation_Output))

'''
Confusion Matrix and Statistics


Att Fake KinC Mit Prox Sim
Att   67    1    0  30    9   4
Fake   0    0    0   0    0   0
KinC  18    0   25   2   17   8
Mit    0    0    0   0    0   0
Prox  22    0    5  14   62   0
Sim    0    0    0   0    0   0

Overall Statistics

Accuracy : 0.5423          
95% CI : (0.4824, 0.6012)
No Information Rate : 0.3768          
P-Value [Acc > NIR] : 1.118e-08       

Kappa : 0.3592          

Mcnemars Test P-Value : NA              

Statistics by Class:

                     Class: Att Class: Fake Class: KinC Class: Mit Class: Prox Class: Sim
Sensitivity              0.6262    0.000000     0.83333      0.000      0.7045    0.00000
Specificity              0.7514    1.000000     0.82283      1.000      0.7908    1.00000
Pos Pred Value           0.6036         NaN     0.35714        NaN      0.6019        NaN
Neg Pred Value           0.7688    0.996479     0.97664      0.838      0.8564    0.95775
Prevalence               0.3768    0.003521     0.10563      0.162      0.3099    0.04225
Detection Rate           0.2359    0.000000     0.08803      0.000      0.2183    0.00000
Detection Prevalence     0.3908    0.000000     0.24648      0.000      0.3627    0.00000
Balanced Accuracy        0.6888    0.500000     0.82808      0.500      0.7477    0.50000

'''

varimp <- varimp(ctree_model, conitional = TRUE)

'''
ScalePoint_Base Cxn 
1.146153        1.036975 
'''
