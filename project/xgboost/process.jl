using DataFrames

include("../naive/util.jl")

df       = readtable("../data/cs-training.csv")[2:end]
df       = shuffle(df)
spliter  = .7 * nrow(df) |> round(Int)
df_train = df[1:spliter-1, :]
df_test  = df[spliter:end, :]

writetable("train.processed.csv", df_train)
writetable("test.processed.csv", df_test)
