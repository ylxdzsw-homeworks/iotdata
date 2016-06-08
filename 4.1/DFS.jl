"""
limit < 0 means unlimited
"""
function DFS!(departure::Node{Void}, destination::Node{Void}, limit::Int, stack::Set{Node})
    if departure == destination return [departure] end
    if limit == 0 return :cutoff end

    push!(stack, departure)
    cutoff = false
    for i in keys(departure.neighbours)
        i in stack && continue
        r = DFS!(i, destination, limit-1, stack)
        if isa(r, Symbol)
            cutoff |= r == :cutoff
        else
            return push!(r, departure)
        end
    end

    delete!(stack, departure)
    cutoff ? :cutoff : :failure
end

function DFS(G::Module, departure::AbstractString, destination::AbstractString)
    G           = gengraph(G, Void)
    departure   = findnode(G, departure)
    destination = findnode(G, destination)
    path        = DFS!(departure, destination, -1, Set{Node}())

    path == :failure && error("unreachable")
    cost = mapreduce(+, Δ(path)) do x x[1].neighbours[x[2]] end
    cost, join(reverse(map(name, path)), " -> ")
end
