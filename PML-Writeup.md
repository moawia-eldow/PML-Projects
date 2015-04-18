# Machine Learning Algorithm to Predict Activity Quality from Activity Monitors
Moawia Eldow  

### Introduction:

This project used data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways (1). The goal of this project is to predict the manner in which they did the exercise. We built the model using machine learning, and we used cross validation of handout of the two datsets of training and testing. We also used our prediction model to predict the test cases in the testing set, and then we generated the errors using the confusion matrix. 

### Loading and Cleaning Data: 

We start by loading the data from two files of pml-trainging.csv and pml-testing.csv and show the dimensions


```r
trainPML <- read.csv("pml-training.csv")
dim(trainPML)
```

```
## [1] 19622   160
```

```r
testPML <- read.csv("pml-testing.csv")
dim(testPML)
```

```
## [1]  20 160
```

Since the data contains 160 varaibles with some additional variables used by creaters, it also contains many blanks and NAs, we will first remove the additional columns that will not contribute in model. Secondly, we remove the variables with NAs and blank in the two sets.We reach to reduce the number of variables to 53 variables in the two sets.


```r
trainData <- subset (trainPML , select = -X: -num_window)
testData <- subset (testPML , select = -X: -num_window)
trainData <- trainData[, sapply(trainData, function(x) !any(is.na(x)))]
trainData <- trainData[, sapply(trainData, function(x) !any(x==""))]
dim(trainData)
```

```
## [1] 19622    53
```

```r
testData <- testData[, sapply(testData, function(x) !any(is.na(x)))]
dim(testData)
```

```
## [1] 20 53
```


### Cross-Validation and Building the Machine Learning Model:

Here, we will adopt the handout cross-validation by generating two datasets - training and testing.


```r
library (caret)
```

```
## Warning: package 'caret' was built under R version 3.1.3
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```
## Warning: package 'ggplot2' was built under R version 3.1.2
```

```r
set.seed (33833)
trainIndex = createDataPartition(trainData$classe, p = 3/4)[[1]]
training = trainData[trainIndex,]
testing = trainData[-trainIndex,]
```

Then, we build the model of machine learning using the random forest.


```r
library (randomForest)
```

```
## Warning: package 'randomForest' was built under R version 3.1.3
```

```
## randomForest 4.6-10
## Type rfNews() to see new features/changes/bug fixes.
```

```r
predictors <- training [, -53]
decision <- training [, 53]
rfMD <- randomForest (predictors, decision)
```


### Setting the Confusion Matrix of Errors and Prediction on Test Dataset:

Now, we use the testing dataset to generate the prediction class, and then the confusion matrix. we have found the whole accuracy of the model is 99%. The following table shows the different error measures for the 5 classes of the manner.


```r
predClass <- predict (rfMD, testing)
confusionMatrix (testing$classe,predClass)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1393    2    0    0    0
##          B    3  943    3    0    0
##          C    0    5  849    1    0
##          D    0    0    2  801    1
##          E    0    0    1    2  898
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9959          
##                  95% CI : (0.9937, 0.9975)
##     No Information Rate : 0.2847          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9948          
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9979   0.9926   0.9930   0.9963   0.9989
## Specificity            0.9994   0.9985   0.9985   0.9993   0.9993
## Pos Pred Value         0.9986   0.9937   0.9930   0.9963   0.9967
## Neg Pred Value         0.9991   0.9982   0.9985   0.9993   0.9998
## Prevalence             0.2847   0.1937   0.1743   0.1639   0.1833
## Detection Rate         0.2841   0.1923   0.1731   0.1633   0.1831
## Detection Prevalence   0.2845   0.1935   0.1743   0.1639   0.1837
## Balanced Accuracy      0.9986   0.9956   0.9958   0.9978   0.9991
```

Finally, we will use the model to generate the prediction vector for the 20 cases in the test set. So that, this will be very useful for the submission project.


```r
PredTest20 <- predict (rfMD, testData)
PredTest20
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E
```

### References:

(1) Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . Stuttgart, Germany: ACM SIGCHI, 2013, (The Weight Lifting Exercise Dataset - http://groupware.les.inf.puc-rio.br/har).
