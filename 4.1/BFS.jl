"""
Node.data is the last node in the path to this one.
Thus !node.data.isnull means node is either explored or in frontier
"""
function BFS!(G::Graph{Node}, departure::Node{Node}, destination::Node{Node})
    departure.data = departure
    frontier = [departure]

    while !isempty(frontier)
        node = shift!(frontier)
        for i in keys(node.neighbours)
            if i.data.isnull
                i.data = Nullable(node)
                i == destination && return BFS_solution(G, departure, destination)
                push!(frontier, i)
            end
        end
    end

    error("unreachable")
end

function BFS(G::Module, departure::AbstractString, destination::AbstractString)
    G           = gengraph(G, Node)
    departure   = findnode(G, departure)
    destination = findnode(G, destination)
    BFS!(G, departure, destination)
end

function BFS_solution(G::Graph{Node}, departure::Node{Node}, destination::Node{Node})
    cost, i, path = 0, destination, AbstractString[]
    while i != departure
        cost += i.neighbours[i.data.value]
        push!(path, i.name)
        i = i.data.value
    end
    push!(path, i.name)
    cost, join(reverse(path), " -> ")
end
