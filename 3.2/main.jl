using DataFrames
using Gadfly
using ProgressMeter

include("util.jl")
include("model.jl")
include("eval.jl")

df_train = readtable("train.csv", header=false)
df_test  = readtable("test.csv", header=false)

df_train = rebalance(df_train, df_train[end])

model = MultilayerPerceptronClassifier(22, 5, 1)
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "Multilayer Perceptron Classifier 22x5x1 (balanced)")
auc(preds, df_test[end])

model = MultilayerPerceptronClassifier(22, 10, 1)
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "Multilayer Perceptron Classifier 22x10x1 (balanced)")
auc(preds, df_test[end])

model = MultilayerPerceptronClassifier(22, 15, 1)
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "Multilayer Perceptron Classifier 22x15x1 (balanced)")
auc(preds, df_test[end])

model = MultilayerPerceptronClassifier(22, 20, 1)
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "Multilayer Perceptron Classifier 22x20x1 (balanced)")
auc(preds, df_test[end])

model = MultilayerPerceptronClassifier(22, 25, 1)
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "Multilayer Perceptron Classifier 22x25x1 (balanced)")
auc(preds, df_test[end])

model = MultilayerPerceptronClassifier(22, 10, 5, 1)
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "Multilayer Perceptron Classifier 22x10x5x1(balanced)")
auc(preds, df_test[end])

model = MultilayerPerceptronClassifier(22, 15, 5, 1)
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "Multilayer Perceptron Classifier 22x15x5x1(balanced)")
auc(preds, df_test[end])

model = MultilayerPerceptronClassifier(22, 10, 10, 10, 1)
model = fit!(model, df_train[:,1:end-1], df_train[end])
preds = pred(model, df_test[:,1:end-1])
roc(preds, df_test[end], "Multilayer Perceptron Classifier 22x10x10x10x1(balanced)")
auc(preds, df_test[end])
