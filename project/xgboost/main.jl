using DataFrames
using Gadfly
include("../../../krife.jl/src/krife.jl")
include("../naive/util.jl")
include("../naive/eval.jl")
using krife

trainX, trainY, testX, testY = let
    df_train = readtable("train.processed.csv")
    df_test  = readtable("test.processed.csv")
    trainX   = df_train[2:end] |> DataArray
    trainY   = df_train[1]     |> DataArray
    testX    = df_test[2:end]  |> DataArray
    testY    = df_test[1]      |> DataArray

    trainX, trainY, testX, testY
end

writelibsvm("train.libsvm", trainX, trainY)
writelibsvm("test.libsvm", testX)

run(`bash -c "xgboost train.xgboost.conf"`)
run(`bash -c "xgboost test.xgboost.conf"`)

result = readcsv("pred.txt") |> squeeze(2)
roc(result, testY, "XGBoost Classifier (AUC=0.8322)")
auc(result, testY)
