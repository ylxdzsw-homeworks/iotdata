sigmoid(x::Float64) = 1 / (1 + e^-x)

dist(x::AbstractVector{Float64}, y::AbstractVector{Float64}) = (x .- y) .^ 2 |> sum

car(x::Tuple) = x[1]
cdr(x::Tuple) = x[2]
