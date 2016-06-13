function Astar!(G::Graph{Tuple{Node, Int}}, departure::Node{Tuple{Node, Int}}, destination::Node{Tuple{Node, Int}})
    departure.data = departure, 0
    frontier = PriorityQueue(Node, Int)
    enqueue!(frontier, departure, 0)

    while !isempty(frontier)
        node, cost = dequeue_with_key!(frontier)
        node == destination && return Astar_solution(G, departure, destination)
        for (i,c) in node.neighbours
            c += ĝ(node)
            if i.data.isnull || ĝ(i) > c
                i.data = Nullable((node, c))
                frontier[i] = f̂(i)
            end
        end
    end

    error("unreachable")
end

function Astar(G::Module, departure::AbstractString, destination::AbstractString)
    G           = gengraph(G, Tuple{Node, Int})
    departure   = findnode(G, departure)
    destination = findnode(G, destination)
    Astar!(G, departure, destination)
end

function Astar_solution(G::Graph{Tuple{Node, Int}}, departure::Node{Tuple{Node, Int}}, destination::Node{Tuple{Node, Int}})
    cost, i, path = 0, destination, AbstractString[]
    while i != departure
        cost += i.neighbours[i.data.value |> car]
        push!(path, i.name)
        i = i.data.value |> car
    end
    push!(path, i.name)
    cost, join(reverse(path), " -> ")
end

@inline ĝ(x::Node) = x.data.value |> cadr
@inline ĥ(x::Node) = x.direct_distance
@inline f̂(x::Node) = ĝ(x) + ĥ(x)
