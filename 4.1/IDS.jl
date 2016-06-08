function IDS(G::Module, departure::AbstractString, destination::AbstractString)
    G           = gengraph(G, Void)
    departure   = findnode(G, departure)
    destination = findnode(G, destination)
    i           = 0

    local r::Union{Symbol, Vector{Node{Void}}}
    while true
        r = DFS!(departure, destination, i, Set{Node}())
        if r == :failure
            error("unreachable")
        elseif r == :cutoff
            i += 1
        else
            break
        end
    end

    cost = mapreduce(+, Δ(r)) do x x[1].neighbours[x[2]] end
    cost, join(reverse(map(name, r)), " -> ")
end
