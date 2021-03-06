import StatsBase.fit!

#==== base type ====#
abstract Classifier
fit!(model::Classifier, X::DataFrame, y::AbstractVector; kwargs...) = fit!(model, Matrix(X), Vector(y); kwargs...)
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

#==== Multilayer Perceptron ====#
type MultilayerPerceptronClassifier <: BinaryClassifier
    layers::Vector{Int}
    w::Vector{Matrix{Float64}}

    MultilayerPerceptronClassifier(x...) = new(collect(x))
end

function fit!(model::MultilayerPerceptronClassifier, X::Matrix{Float64}, y::Vector{Int};
              nrounds::Int=100, μ::Float64=1., λ::Float64=1.)
    layers = model.layers
    nlayers = length(layers)
    n = size(X, 1)
    x = Vector{Matrix}(nlayers)
    u = Vector{Matrix}(nlayers)
    w = map(1:nlayers-1) do x rand(layers[x+1], layers[x]+1) - .5 end
    δ = Vector{Matrix}(nlayers)
    y = map(y) do x x==1 ? 1 : 0 end
    intercept = ones(n, 1)
    x[1] = [intercept X]

    @showprogress 1 "trainning..." for nround in 1:nrounds
        μ -= μ / nrounds

        for i in 2:nlayers
            u[i] = x[i-1] * w[i-1]'
            x[i] = [intercept map(sigmoid, u[i])]
        end

        # 反向传播
        δ[nlayers] = (x[nlayers][:, [2]] - y) .* map(sigmoid_gradient, u[nlayers])
        for i in nlayers-1:-1:2
            δ[i] = (δ[i+1] * w[i][:, 2:end]) .* map(sigmoid_gradient, u[i])
            w[i] -= μ * δ[i+1]' * x[i] / n
        end
        w[1] -= μ * δ[2]' * x[1] / n
    end

    model.w = w
    model
end

function pred(model::MultilayerPerceptronClassifier, X::Matrix{Float64})
    layers, w = model.layers, model.w
    n, nlayers = size(X, 1), length(layers)
    x, u = Vector{Matrix}(nlayers), Vector{Matrix}(nlayers)
    intercept = ones(n, 1)
    x[1] = [intercept X]
    for i in 2:nlayers
        u[i] = x[i-1] * w[i-1]'
        x[i] = [intercept map(sigmoid, u[i])]
    end
    u[nlayers][:]
end
