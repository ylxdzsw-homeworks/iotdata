sigmoid(x::Float64) = 1 / (1 + e^-x)
sigmoid_gradient(x::Float64) = sigmoid(x) * (1-sigmoid(x))

dist(x::AbstractVector{Float64}, y::AbstractVector{Float64}) = (x .- y) .^ 2 |> sum

car(x::Tuple) = x[1]
cdr(x::Tuple) = x[2]

rebalance(df_train, y) = begin
    p = find(y.==1)
    diff = length(y) - 2length(p)
    s = sample(p, diff)
    [df_train; df_train[s, :]]
end

import Base.round
round(x::DataType) = y -> round(x, y)

import Base.shuffle
shuffle(x::DataFrame) = x[shuffle!(collect(1:nrow(df))), :]

import Base.squeeze
squeeze(x::Int) = y -> squeeze(y, x)

import Base.split
split(x::Char) = y -> split(y, x)
