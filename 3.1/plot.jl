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
