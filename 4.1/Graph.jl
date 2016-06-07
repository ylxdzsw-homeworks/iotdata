type Node{T}
    name::AbstractString
    neighbours::Dict{Node, Int}
    direct_distance::Int
    data::Nullable{T}

    Node(x::AbstractString, d::Int) = new(x, Dict{Node, Int}(), d, Nullable{T}())
end

immutable Graph{T}
    nodes::Vector{Node{T}}
end

function gengraph(x::Module, dt::Type)
    nodes = Dict{AbstractString, Node{dt}}()

    for (n,d) in x.direct_distances
        nodes[n] = Node{dt}(n, d)
    end

    for (a,b,d) in x.edges
        nodes[a].neighbours[nodes[b]] = d
        nodes[b].neighbours[nodes[a]] = d
    end

    nodes |> values |> collect |> Graph{dt}
end

function findnode(G::Graph, x::AbstractString)
    G.nodes[findfirst(n->n.name==x, G.nodes)]
end
