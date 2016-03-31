
#require (ggplot2)
require (rpart)

basicData = read.csv("EntrData.csv",row.names=1)
structData = read.csv("struct.csv",row.names=1)

allData = data.frame(basicData,structData)
cleanData = subset(allData, allData$maxJumpSize !=-Inf & allData$minJumpSize !=Inf)

# A function for fitting a data set with two models and returning its predictive success
modelFunc = function( Data ){
   trainInd = sample(1:nrow(Data), round(nrow(Data)*.8))
   trainData = Data[trainInd, ]
   testData = Data[-trainInd, ]

   modelL = lm(data=trainData, Type ~ .)
   predL = predict(modelL, testData)

   predTmp = predict(modelL, trainData)
   trshold = (max(subset(predTmp,trainData$Type==0)) + min(subset(predTmp,trainData$Type==1)))/2
   predL = predL > trshold

   nTest = nrow(testData)
   nonVir = nrow(subset(testData,Type==0))
   isVirn = nTest - nonVir

   rateL = 100*sum((testData$Type) ==predL)/nTest
   truePosL = 100*sum(subset(predL, testData$Type==1) == 1 )/isVirn
   trueNegL = 100*sum(subset(predL, testData$Type==0) == 0 )/nonVir

   modelT = rpart(data=trainData, Type ~ .)
   predT = predict(modelT, testData)

   predTmp = predict(modelT, trainData)
   trsholdT = (max(subset(predTmp,trainData$Type==0)) + min(subset(predTmp,trainData$Type==1)))/2
   predT = predT > trsholdT

   rateT = 100*sum((testData$Type) ==predT)/nTest
   truePosT = 100*sum(subset(predT, testData$Type==1) == 1 )/isVirn
   trueNegT = 100*sum(subset(predT, testData$Type==0) == 0 )/nonVir

   return(c(rateL, truePosL, trueNegL, rateT, truePosT, trueNegT))
}

#  Many separate (no over fitting) fitting rounds to "compansate" for
#  small amount of data. Compensate for less variability, not lack of data.
n=100
sumAll = c(0,0,0,0,0,0)
for (i in 1:n){
   sumAll = sumAll + modelFunc(cleanData)
}

avrgRate = sumAll/n
#Model L = Over All: 89.94; Virus Detection: 78.11; False Pos.: 5.17 
#Model T = Over All: 91.36; Virus Detection: 79.89; False Pos.: 3.93
