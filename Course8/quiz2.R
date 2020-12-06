library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]


### Q4
IL <- grep("^IL", colnames(adData))
prepIL <- preProcess(adData[IL], method="pca", thresh=0.8)


### Q5
trainingIL <- cbind(training[IL], training["diagnosis"])

# model 1
model1 <- train(data=trainingIL, diagnosis~., method="glm")
confusionMatrix(testing$diagnosis, predict(model1, testing))

# model 2
prepIL <- preProcess(trainingIL, method="pca", thresh=0.8)
fitControl <- trainControl(preProcOptions = list(thresh=0.8))
model2 <- train(data=trainingIL, diagnosis~., method="glm", preProcess = "pca", trControl=fitControl)
confusionMatrix(testing$diagnosis, predict(model2, testing))