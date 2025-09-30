# HowToBeHalfHeadless_Data
Data and code for the paper "How can one be “half headless”?  The interaction of scalar features and constructional semantics in Italian approximating HALF + Adjective constructions".

## Conditional Inference Trees
Output of the two CITs. The first employs token counts of adjectival bases, while the second employs type counts. Type counts were calculated by crossing each of the three variables, so a single type can appear more than once in the model if i.e., it is used with both the constructions, or if it yields different semantic outputs.

The two models largely overlap, as the splits are the same: in fact, in the type-based model the order of Cxn and ScalePoint_Base as splitting factors is only swapped in the sub-tree depending from node 5, but it leads to the same conclusions as the token-based model. The only strong difference between the two models pertains their accuracy, which is higher in the case of token counts (0.67 vs 0.54).


### Token-based model

```
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
```

- Conditional variable importance:

  ```
  ScalePoint_Base             Cxn 
      1.3068032       0.8097854

  ```

  
- Performance

  ```
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
  ```

### Type-based model


```
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

```


- Conditional variable importance:

  ```
  ScalePoint_Base Cxn 
  1.146153        1.036975 
  ```

  
- Performance

  ```
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

  ```
