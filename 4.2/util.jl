@inline car(x::Tuple) = x[1]
@inline cadr(x::Tuple) = x[2]

Δ{T}(x::Vector{T}) = Tuple{T,T}[(x[i+1],x[i]) for i in 1:length(x)-1]
Δ(f::Function, x::Vector) = [f(x[i+1],x[i]) for i in 1:length(x)-1]
Δ{T}(f::Function, ::Type{T}, x::Vector) = T[f(x[i+1],x[i]) for i in 1:length(x)-1]

∘(f::Function, g::Function) = x->f(g(x))

function dequeue_with_key!(pq::PriorityQueue)
    x = peek(pq)
    dequeue!(pq)
    x
end
