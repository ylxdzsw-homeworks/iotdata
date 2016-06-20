using DataFrames
using Gadfly
using ProgressMeter

include("util.jl")
include("model.jl")
include("eval.jl")

df = readtable("../data/cs-training.csv")[2:end]
df[1] = df[1] * 2 - 1

#=== balance ===#
sum(df[1] .== -1) / sum(df[1] .== 1)
df = rebalance(df, df[1])

#=== na ===#
for i in names(df) any(isna, df[i]) && println(i) end
df[isna(df[:MonthlyIncome]), :MonthlyIncome] = df[:MonthlyIncome] |> each_dropna |> mean |> round(Int)
df[isna(df[:NumberOfDependents]), :NumberOfDependents] = df[:NumberOfDependents] |> each_dropna |> collect |> mode

#=== normaliazation ===#
for i in names(df[2:end])
    df[i] -= mean(df[i])
    df[i] /= std(df[i])
end

#=== cv ===#
df       = shuffle(df)
spliter  = .7 * nrow(df) |> round(Int)
df_train = df[1:spliter-1, :]
df_test  = df[spliter:end, :]

model = NearestCenterClassifier()
model = fit!(model, df_train[:,2:end], df_train[1])
preds = pred(model, df_test[:,2:end])
roc(preds, df_test[1], "Nearest Center Classifier")
auc(preds, df_test[1])

model = McCullochPittsClassifier()
model = fit!(model, df_train[:,2:end], df_train[1])
preds = pred(model, df_test[:,2:end])
roc(preds, df_test[1], "McCulloch Pitts Classifier")
auc(preds, df_test[1])

model = MultilayerPerceptronClassifier(10, 18, 1)
model = fit!(model, df_train[:,2:end], df_train[1])
preds = pred(model, df_test[:,2:end])
roc(preds, df_test[1], "Multilayer Perceptron Classifier 10x18x1")
auc(preds, df_test[1])

for i = 25:2:31
    model = MultilayerPerceptronClassifier(10, i, 1)
    model = fit!(model, df_train[:,2:end], df_train[1])
    preds = pred(model, df_test[:,2:end])
    println(i, ": ", auc(preds, df_test[1]))
end

# 11 : 0.6341
# 13 : 0.6138
# 15 : 0.6218
# 17 : 0.6417
# 19 : 0.6408
# 21 : 0.6437
# 23 : 0.6526
# 25 : 0.6534
# 27 : 0.6515
# 29 : 0.6483
# 31 : 0.6535
