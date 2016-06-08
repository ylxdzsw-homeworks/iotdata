function UCS!(G::Graph{Node}, departure::Node{Node}, destination::Node{Node})
    departure.data = departure
    frontier = PriorityQueue(Node, Int)
    enqueue!(frontier, departure, 0)

    while !isempty(frontier)
        node, cost = dequeue_with_key!(frontier)
        node == destination && return UCS_solution(G, departure, destination)
        for (i,c) in node.neighbours
            c += cost
            if i.data.isnull || get(frontier, i, 0) > c
                i.data = Nullable(node)
                frontier[i] = c
            end
        end
    end

    error("unreachable")
end

function UCS(G::Module, departure::AbstractString, destination::AbstractString)
    G           = gengraph(G, Node)
    departure   = findnode(G, departure)
    destination = findnode(G, destination)
    UCS!(G, departure, destination)
end

function UCS_solution(G::Graph{Node}, departure::Node{Node}, destination::Node{Node})
    cost, i, path = 0, destination, AbstractString[]
    while i != departure
        cost += i.neighbours[i.data.value]
        push!(path, i.name)
        i = i.data.value
    end
    push!(path, i.name)
    cost, join(reverse(path), " -> ")
end
