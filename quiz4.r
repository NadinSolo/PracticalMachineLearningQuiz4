#1.
library(pgmm)
library(rpart)
library(gbm)
library(lubridate)
library(forecast)
library(e1071)
library(AppliedPredictiveModeling)
library(caret)
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)
str(vowel.train)

set.seed(33833)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)
set.seed(33833)
mod_rf <- train(y ~ ., data = vowel.train, method = "rf")
mod_gbm <- train(y ~ ., data = vowel.train, method = "gbm")
pred_rf <- predict(mod_rf, vowel.test)
pred_gbm <- predict(mod_gbm, vowel.test)
confusionMatrix(pred_rf, vowel.test$y)$overall[1]
confusionMatrix(pred_gbm, vowel.test$y)$overall[1]
predDF <- data.frame(pred_rf, pred_gbm, y = vowel.test$y)
# Accuracy among the test set samples where the two methods agree
sum(pred_rf[predDF$pred_rf == predDF$pred_gbm] == 
      predDF$y[predDF$pred_rf == predDF$pred_gbm]) / 
  sum(predDF$pred_rf == predDF$pred_gbm)

#2.
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)

adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
set.seed(62433)
mod_rf <- train(diagnosis ~ ., data = training, method = "rf")
mod_gbm <- train(diagnosis ~ ., data = training, method = "gbm")
mod_lda <- train(diagnosis ~ ., data = training, method = "lda")
pred_rf <- predict(mod_rf, testing)
pred_gbm <- predict(mod_gbm, testing)
pred_lda <- predict(mod_lda, testing)
str(testing)
predDF <- data.frame(pred_rf, pred_gbm, pred_lda, diagnosis = testing$diagnosis)
combModFit <- train(diagnosis ~ ., method = "rf", data = predDF)
combPred <- predict(combModFit, predDF)
# Accuracy using random forests
confusionMatrix(pred_rf, testing$diagnosis)$overall[1]

#Accuracy using boosting
confusionMatrix(pred_gbm, testing$diagnosis)$overall[1]
#Accuracy using linear discriminant analysis
confusionMatrix(pred_lda, testing$diagnosis)$overall[1]
# Stacked Accuracy
confusionMatrix(combPred, testing$diagnosis)$overall[1]

#3.
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)

inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
set.seed(233)
mod_lasso <- train(CompressiveStrength ~ ., data = training, method = "lasso")
library(elasticnet)

library(lars)
plot.enet(mod_lasso$finalModel, xvar = "penalty", use.color = TRUE)

#4.
library(lubridate)
library(stats)
dat<-read.table("/Users/Toshiba/Downloads/gaData.csv")
training = dat[year(dat$date) < 2012,]
testing = dat[(year(dat$date)) > 2011,]
tstrain = ts(training$visitsTumblr)



head(dat)
library(forecast)
mod_ts<-bats(tstrain)


#5.
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)

inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
set.seed(325)
library(e1071)
mod_svm <- svm(CompressiveStrength ~ ., data = training)
pred_svm <- predict(mod_svm, testing)
accuracy(pred_svm, testing$CompressiveStrength)


?ts()

