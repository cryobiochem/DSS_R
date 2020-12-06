library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)


# Q1


# create training and test sets
partition <- createDataPartition(y=segmentationOriginal$Case,p=0.7, list=FALSE)
training <- segmentationOriginal[partition,]
testing <- segmentationOriginal[-partition,]

# cart model
set.seed(125)
CART <- train(Class ~ .,method="rpart",data=training, tuneLength=10)
fancyRpartPlot(CART$finalModel)



# Q3
library(pgmm)
data(olive)
olive = olive[,-1]

fitTree =  train(Area ~., data=olive, method='rpart')
fancyRpartPlot(fitTree$finalModel)
predict(fitTree, newdata = as.data.frame(t(colMeans(olive))))


# Q4
library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]

set.seed(13234)
lgModel = train(method=glm(family='binomial'), data=SAheart, chd~age+alcohol+obesity+tabacco+typeA+lipo)

missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}

predict(lgModel, response)