using DataFrames
using Gadfly

include("util.jl")
include("model.jl")
include("eval.jl")

df_train = readtable("train.csv", header=false)
df_test  = readtable("test.csv", header=false)

model = NearestCenterClassifier()
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "Nearest Center Classifier (unbalanced)")
auc(preds, df_test[end])

model = McCullochPittsClassifier()
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "McCulloch-Pitts Classifier (unbalanced)")
auc(preds, df_test[end])

df_train = rebalance(df_train, df_train[end])

model = NearestCenterClassifier()
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "Nearest Center Classifier (balanced)")
auc(preds, df_test[end])

model = McCullochPittsClassifier()
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "McCulloch-Pitts Classifier (balanced)")
auc(preds, df_test[end])
