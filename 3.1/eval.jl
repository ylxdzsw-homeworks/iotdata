roc(p::AbstractVector{Float64}, y::AbstractVector{Int}, title::AbstractString) = roc(Vector(p), Vector(y), title)
function roc(p::Vector{Float64}, y::Vector{Int}, title::AbstractString)
    p = map(sigmoid, p ./ std(p))
    T = y.==1
    F = !T

    points = map(0:0.01:1) do i
        P = p.>=i
        TP = sum(T & P) / sum(T)
        FP = sum(F & P) / sum(F)
        (FP, TP)
    end

    plot(x=map(car, points), y=map(cdr, points),
         Guide.xlabel("FP"), Guide.ylabel("TP"),
         Geom.line, Guide.title("ROC of $title"))
end

auc(p::AbstractVector{Float64}, y::AbstractVector{Int}) = auc(Vector(p), Vector(y))
function auc(p::Vector{Float64}, y::Vector{Int})
    p = map(sigmoid, p ./ std(p))
    T = y.==1
    F = !T

    points = map(0:0.01:1) do i
        P = p.>=i
        TP = sum(T & P) / sum(T)
        FP = sum(F & P) / sum(F)
        (FP, TP)
    end

    ∫ = map(2:100) do i
        x1, y1 = points[i-1]
        x2, y2 = points[i]
        (x1 - x2) * (y1 + y2) / 2
    end

    sum(∫)
end
