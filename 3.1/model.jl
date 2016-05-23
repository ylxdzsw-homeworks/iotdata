import StatsBase.fit!

#==== base type ====#
abstract Classifier
fit!(model::Classifier, X::DataFrame, y::AbstractVector) = fit!(model, Matrix(X), Vector(y))
pred(model::Classifier, X::DataFrame) = pred(model, Matrix(X))

abstract BinaryClassifier <: Classifier

#==== Nearest Center ====#
type NearestCenterClassifier <: BinaryClassifier
    positiveCenter::Vector{Float64}
    negativeCenter::Vector{Float64}

    NearestCenterClassifier() = new()
end

function fit!(model::NearestCenterClassifier, X::Matrix{Float64}, y::Vector{Int})
    model.positiveCenter = mean(X[y.==+1, :], 1)[:] # along the first dimension
    model.negativeCenter = mean(X[y.==-1, :], 1)[:]
    model
end

function pred(model::NearestCenterClassifier, X::Matrix{Float64})
    map(1:size(X, 1)) do i
        p = X[i, :][:]
        dist(p, model.negativeCenter) - dist(p, model.positiveCenter)
    end
end

#==== McCulloch-Pitts ====#
type McCullochPittsClassifier <: BinaryClassifier
    boundary::Vector{Float64}

    McCullochPittsClassifier() = new()
end

function fit!(model::McCullochPittsClassifier, X::Matrix{Float64}, y::Vector{Int})
    const η = 1
    w = rand(-1:.5:1, size(X, 2))
    for i in 1:100
        F = X * w .* y
        F = F[:] .< 0
        L = X[F, :]
        L = y[F]' * L
        w += η * L[:]
    end
    model.boundary = w
    model
end

function pred(model::McCullochPittsClassifier, X::Matrix{Float64})
    X * model.boundary
end
