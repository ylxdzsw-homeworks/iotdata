using DataFrames
using Gadfly

include("util.jl")
include("model.jl")
include("plot.jl")

const df_train = readtable("train.csv", header=false)
const df_test  = readtable("test.csv", header=false)

model = NearestCenterClassifier()
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "Nearest Center Classifier")

model = McCullochPittsClassifier()
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "McCulloch-Pitts Classifier")
