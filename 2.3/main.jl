using DataFrames

println("空气质量：")
df = readtable("TrainingData.csv")

# for numeric data, fill missing value with mean
fill{T<:Real}(x::DataVector{T}) = begin
    x[isna(x)] = x[!isna(x)] |> mean |> floor
end

# for categoric data, fill missing value with mode
fill{T<:AbstractString}(x::DataVector{T}) = begin
    x[isna(x)] = x[!isna(x)] |> mode
end

# fill all missing values
for i in df.columns
    fill(i)
end

# calc cor
function cor(a, b)
    ma, mb = mean(a), mean(b)
    σa, σb = std(a), std(b)
    (sum(a.*b)-n*ma*mb) / ((n-1)*σa*σb)
end

n = nrow(df)
a, b = df[:Solar_radiation_64], df[:target_1_57]
println("cor: ", cor(a, b))

# calc χ2
function χ2(a, b)
    x, y = unique(a), unique(b)
    acc = 0
    for i in x
        p = sum(a.==i)/n
        for j in y
            q = sum(b.==j)
            acc += (sum(b[a.==i].==j) - p*q)^2 / (p*q)
        end
    end
    println("df: ", (length(x)-1)*(length(y)-1))
    acc
end

a, b = df[:weekday], df[:Sample_Baro_Pressure_52]
a = map(a) do x x in ["Sunday", "Saturday"] end # devied into 2calsses
b = map(b) do x div(x-731, 15) end # divied into 3 classes
println("χ2: ", χ2(a, b))

println("通话数据：")
df = readtable("processed.csv")
a, b = df[:通信时长], df[:亲密性]
println("cor:", cor(a, b))
q1, mid, q3 = quantile(a, [.25, .5, .75])
a = map(a) do x
    if x < q1 1
    elseif x < mid 2
    elseif x < q3 3
    else 4
    end
end
println("χ2: ", χ2(a, b))
