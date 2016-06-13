using Base.Collections

include("util.jl")
include("Graph.jl")

include("BFS.jl")
include("UCS.jl")
include("DFS.jl")
include("IDS.jl")
include("Astar.jl")

include("HIT.data")
include("Romania.data")

BFS(HIT, "正心楼", "诚意楼")
UCS(HIT, "正心楼", "诚意楼")
DFS(HIT, "正心楼", "诚意楼")
IDS(HIT, "正心楼", "诚意楼")
Astar(HIT, "正心楼", "诚意楼")

BFS(Romania, "Arad", "Bucharest")
UCS(Romania, "Arad", "Bucharest")
DFS(Romania, "Arad", "Bucharest")
IDS(Romania, "Arad", "Bucharest")
Astar(Romania, "Arad", "Bucharest")

@time for i in 1:1000
    BFS(HIT, "正心楼", "诚意楼")
    BFS(Romania, "Arad", "Bucharest")
end

@time for i in 1:1000
    UCS(HIT, "正心楼", "诚意楼")
    UCS(Romania, "Arad", "Bucharest")
end

@time for i in 1:1000
    DFS(HIT, "正心楼", "诚意楼")
    DFS(Romania, "Arad", "Bucharest")
end

@time for i in 1:1000
    IDS(HIT, "正心楼", "诚意楼")
    IDS(Romania, "Arad", "Bucharest")
end

@time for i in 1:1000
    Astar(HIT, "正心楼", "诚意楼")
    Astar(Romania, "Arad", "Bucharest")
end

for i in Romania.nodes
    Astar(Romania, i, "Bucharest") |> println
end
